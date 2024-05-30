extends Node

class_name NPC

@export var id: int
var associated_llm: String
var conversation_partner: NPC
var mind: Mind = Mind.new()
var is_thinking: bool = false
var is_choosing: bool = false
#var choice_attempts: int = 0
#var timeout_interval: int = 10
# Called when the node enters the scene tree for the first time.
func start():
	#assert(id != null, "WARNING: NPC instance has no id!") this can be used to debug (basically, if then print)
	id = NPCManager.npc_list.size()
	var label: Label = get_child(0)
	label.text = self.name

func check_for_npc_available(): 
	#try to establish communication with another NPC
		for i in range(NPCManager.npc_list.size()): #Goes through all npcs
			_establish_communication(NPCManager.npc_list[i])
			break

func _establish_communication(_npc: NPC): #To use for npc to npc conversation
	if(conversation_partner == null):#if not talking
		if(_npc.id != self.id): #may not call self
			if(_npc.conversation_partner == null): # and the other is not talking
				print(self.name+" initiated conversation with "+_npc.name)
				conversation_partner = _npc
				conversation_partner.conversation_partner = self
				_add_line2D() #adds line from self to conversation partner
				var init_message = "You have chosen to call "+conversation_partner.name+". You are now on the phone. What do you say?"
				request_answer(init_message)
				is_choosing = false

func _on_request_completed(_request_handler: RequestHandler, _dict: Dictionary):
	is_thinking = false
	var reply_string: String = _dict["message"]["content"]
	print(self.name+":")
	print(reply_string)
	print()
	if(conversation_partner!=null): 
		_chat_with(reply_string, conversation_partner) #respond to other
		mind.dialogue_context.append(_dict["message"])
	else: if(is_choosing==false): mind.activity_context.append(_dict["message"]["content"])
	if(is_choosing): #while choosing who to call
		for _npc: NPC in NPCManager.npc_list:
			if(_npc.name == reply_string or (_npc.name.split(" ")[0] == reply_string.split(" ")[0])): 
				_establish_communication(_npc)
		if(conversation_partner==null): 
			print("No NPC was chosen")
			#if(choice_attempts<=3):
			#	request_choice()
			#	print("Attempting anew...")
			#else: print("Aborting attempt!")
	
func request_answer(_message: String): #sends a request to own LLM
	is_thinking = true
	if(conversation_partner != null):
		mind.dialogue_context.append({"role": "user", "content": _message})
	RequestHandlerManager.start_request(self, _message)

func request_choice():
	is_thinking = true
	is_choosing = true
	var _message: String = "It's "+str(GameManager.hour)+GameManager.time_of_day+". You may call one of your neighbors. You know "+NPCManager.get_npc_list_as_string_without_self(self)+". Who would you like to call? You may not call youself. Answer with just the name of the person you would like to call or just no if you want to call nobody. Example:<Their Name> <Their Surname> (without the brackets)"
	#print(_message)
	RequestHandlerManager.start_request(self, _message)
	#choice_attempts+=1

func _chat_with(_message: String, _npc: NPC):
	#print(_message)
	_npc.request_answer(_message)

func _on_conversation_over(_json: Dictionary):
	_remove_line2D()
	print("Conversation between "+self.name+" and "+conversation_partner.name+" terminated.")
	conversation_partner = null
	
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
