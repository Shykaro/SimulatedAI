extends Node

class_name NPC

@export var id: int
var associated_llm: String
@export var conversation_partner: NPC
var mind: Mind = Mind.new()
var is_thinking: bool = false #is generating response
var is_choosing: bool = false #is generating who to call
var is_conversation_over: bool = false
var is_initiator: bool = false #is the one that initiated the converstaion
#var choice_attempts: int = 0
#var timeout_interval: int = 10
# Called when the node enters the scene tree for the first time.
func start():
	#assert(id != null, "WARNING: NPC instance has no id!") this can be used to debug (basically, if then print)
	id = NPCManager.npc_list.size()
	var label: Label = get_child(0)
	label.text = self.name
	mind.associated_npc = self

func _establish_communication(_npc: NPC): #Initiates npc to npc conversation
	
	if(conversation_partner == null):#if not talking
		if(_npc.id != self.id): #may not call self
			if(_npc.conversation_partner == null): # and the other is not talking
				print(self.name+" initiated conversation with "+_npc.name)
				conversation_partner = _npc
				#mind.update_conversation_partner(_npc) #updates conversation partner for mind
				conversation_partner.conversation_partner = self
				_add_line2D() #adds line from self to conversation partner
				is_choosing = false
				is_conversation_over = false
				is_initiator = true
				var init_message = "You have chosen to call "+conversation_partner.name+". You are now on the phone. What do you say?"
				request_answer(init_message)

func _on_request_completed(_request_handler: RequestHandler, _dict: Dictionary): #is called every time a ollama request "comes back"
	is_thinking = false
	print("\n"+self.name+":")
	if(conversation_partner!=null && is_choosing==false): #If talking to someone
		if(is_initiator): 
			mind.check_conversation_over()
			if(is_conversation_over): 
				print("conversation over!")
				_on_conversation_over(_dict) #stops and cleans up conversation
				return
		var reply_string: String = _dict["message"]["content"]
		print(reply_string+"\n")
		_chat_with(reply_string, conversation_partner) #respond to other
		mind.dialogue_context.append(_dict["message"])
	else: if(is_choosing==false): 
		var reply_string: String = _dict["response"]
		print(reply_string)
		print()
		mind.activity_context.append(_dict["response"])
		mind.update_emotional_state(reply_string)
	if(is_choosing): #while choosing who to call
		var reply_string: String = _dict["response"]
		print(reply_string)
		print()
		for _npc: NPC in NPCManager.npc_list:
			if(_npc.name == reply_string or (_npc.name.split(" ")[0] == reply_string.split(" ")[0])): 
				_establish_communication(_npc)
		if(conversation_partner==null): 
			print("No NPC was chosen")
		is_choosing = false

func request_answer(_message: String):
	is_thinking = true
	mind.update_relation_during_conversation(conversation_partner, _message) #0 updated emotional relation MIGHT HAVE TO BE MOVED TO END OF MESSAGE OF OPPOSING NPC?  !!! -> Bug might be in this logic?
	_message += "\n\n Remember: this is what you did today: " + mind.activity_context[0]
	var emotional_relation = mind.get_emotional_relation(conversation_partner.name) #0.1 getted emotional relation
	#print("\n" + "\n" + "Current emotional relation with " + conversation_partner.name + ": " + emotional_relation + "\n")
	_message += "\n\n Take into account your current emotional feelings towards your conversation partner, they are as follows: " + emotional_relation
	if (conversation_partner != null):
		mind.dialogue_context.append({"role": "user", "content": _message})
	RequestHandlerManager.request_chat_api(self, mind.dialogue_context)


func request_activity(): #used for asking for current activity
	is_thinking = true
	var _message: String = ""
	if(!mind.activity_context.is_empty()):
		_message += "These are the things you were doing previously today:\n"
		_message += "\n" + "\n".join(mind.activity_context)+"\n\n"
	_message += "It's "+str(GameManager.hour)+GameManager.time_of_day+". What are you doing right now? Are you sleeping, working or doing something else? (Answer as monologue)"
	RequestHandlerManager.request_generate_api(self, _message)

func request_choice(): #used for getting a name for who they want to call on the phone (npc2npc)
	is_thinking = true
	is_choosing = true
	var _message: String = "It's "+str(GameManager.hour)+GameManager.time_of_day+". You may call one of your neighbors. You know "+NPCManager.get_npc_list_as_string_without_self(self)+". Who would you like to call? You may not call youself. Answer with just the name of the person you would like to call or just no if you want to call nobody. Example:<Their Name> <Their Surname> (without the brackets)"
	#print(_message)
	RequestHandlerManager.request_generate_api(self, _message)
	#choice_attempts+=1

func _chat_with(_message: String, _npc: NPC):
	#print(_message)
	_npc.request_answer(_message)

func _on_conversation_over(_json: Dictionary): #is called in the initiator, handles all cleanup after conversation
	if(is_initiator): _remove_line2D()
	is_initiator = false
	print("Conversation between "+self.name+" and "+conversation_partner.name+" terminated.")
	conversation_partner.conversation_partner = null
	conversation_partner = null
	is_conversation_over = false

func _add_line2D():
	var _line: Line2D = Line2D.new()
	_line.add_point(Vector2.ZERO)
	_line.add_point((conversation_partner.position-self.position)*2)
	_line.name = "Communication Line between "+self.name+" and "+conversation_partner.name
	self.add_child(_line)
	_line.default_color = Color("green")
	_line.z_as_relative = false

func _remove_line2D():
	var _line = self.get_node("Communication Line between "+self.name+" and "+conversation_partner.name)
	self.remove_child(_line)
