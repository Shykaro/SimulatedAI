extends Node

class_name NPC

@export var id: int
var associated_llm: String
@export var conversation_partner: NPC
var last_conversation_partner: NPC #used in mind to label past conversations 
var mind: Mind = Mind.new()
var is_thinking: bool = false #is generating response
var is_choosing: bool = false #is generating who to call
var is_conversation_over: bool = false
var is_initiator: bool = false #is the one that initiated the converstaion
var chatbox
var associatedChatBox # this is the ScrollContainer node of the associated Chatbox
var emotionalbox
#var choice_attempts: int = 0
#var timeout_interval: int = 10
# Called when the node enters the scene tree for the first time.

func start():
	#assert(id != null, "WARNING: NPC instance has no id!") this can be used to debug (basically, if then print)
	id = NPCManager.npc_list.size()
	var label: Label = get_child(0).get_child(0)
	label.text = self.name
	mind.associated_npc = self
	#Instance chatbox for every NPC
	var chatbox_scene = load("res://HUD/Scenes/Chatbox.tscn")
	chatbox = chatbox_scene.instantiate()
	var emotionalbox_scene = load("res://HUD/Scenes/EmotionalBox.tscn")
	emotionalbox = emotionalbox_scene.instantiate()
	#npc_scene.instantiate()
	#instance.add_child(_npc)
	add_child(chatbox)
	add_child(emotionalbox)
	#chatbox.visible = false
	#emotionalbox.visible = false
	#print(get_children()) #check NPC Structure
	associatedChatBox = get_child(1).get_child(0).get_child(0).get_child(3) #Sets reference for future message updates to Scrollcontainer (Which includes chatbox.gd)
	print(associatedChatBox)
	#print(get_parent())
	


func show_chatbox():
	chatbox.visible = true
	#chatbox.update_info(text)

func hide_chatbox():
	chatbox.visible = false

func show_emotionalbox():
	emotionalbox.visible = true
	#chatbox.update_info(text)

func hide_emotionalbox():
	emotionalbox.visible = false

func _establish_communication(_npc: NPC): #Initiates npc to npc conversation
	if(conversation_partner == null):#if not talking
		if(_npc.id != self.id): #may not call self
			if(_npc.conversation_partner == null): # and the other is not talking
				print("---------SYSTEM-------- "+self.name+" initiated conversation with "+_npc.name)
				conversation_partner = _npc
				last_conversation_partner = _npc
				#mind.update_conversation_partner(_npc) #updates conversation partner for mind
				conversation_partner.conversation_partner = self
				conversation_partner.last_conversation_partner = self
				#_add_line2D() #adds line from self to conversation partner
				_add_arrow()
				chatbox.get_child(0).updateChat(conversation_partner.name)
				is_choosing = false
				is_conversation_over = false
				is_initiator = true
				var init_message = "You have chosen to call "+conversation_partner.name+". You are now on the phone. What do you say to start the conversation?"
				request_answer(init_message)

func _on_request_completed(_request_handler: RequestHandler, _dict: Dictionary): #is called every time a ollama request "comes back"
	is_thinking = false
	if(conversation_partner!=null && is_choosing==false): #If talking to someone
		if(is_initiator): 
			mind.check_conversation_over()
			if(is_conversation_over): 
				_on_conversation_over(_dict) #stops and cleans up conversation
				return
		var reply_string: String = _dict["message"]["content"]
		print("\n"+self.name+":")
		print(reply_string+"\n")
		associatedChatBox.createMessage(self, reply_string)
		_chat_with(reply_string, conversation_partner) #respond to other
		mind.dialogue_context.append(_dict["message"])
	else: if(is_choosing==false): 
		var reply_string: String = _dict["response"]
		print("\n"+self.name+":")
		print(reply_string+"\n")
		mind.activity_context.append(_dict["response"])
		mind.update_emotional_state(reply_string)
	if(is_choosing): #while choosing who to call
		var reply_string: String = _dict["response"]
		print("---------SYSTEM-------- "+self.name+" chose to call "+reply_string+"\n")
		for _npc: NPC in NPCManager.npc_list:
			if(_npc.name == reply_string or (_npc.name.split(" ")[0] == reply_string.split(" ")[0])): 
				_establish_communication(_npc)
		if(conversation_partner==null): 
			print("---------SYSTEM-------- "+"No NPC was chosen")
		is_choosing = false

func request_answer(_message: String):
	is_thinking = true
	associatedChatBox.createMessage(conversation_partner, _message)
	if (conversation_partner != null):
		mind.dialogue_context.append({"role": "user", "content": _message})
	if(mind.activity_context!=[]): _message += "\n\n REMEMBER, you may use information from your day for the conversation, this is what you did today: " + mind.activity_context[0]
	mind.update_relation_during_conversation(conversation_partner, _message) #0 updated emotional relation MIGHT HAVE TO BE MOVED TO END OF MESSAGE OF OPPOSING NPC?  !!! -> Bug might be in this logic?
	var emotional_relation = mind.get_emotional_relation(conversation_partner.name) #0.1 getted emotional relation
	#print("---------SYSTEM-------- "+"\n" + "\n" + "Current emotional relation with " + conversation_partner.name + ": " + emotional_relation + "\n")
	if(emotional_relation!=null): _message += "\n\n Take your current emotional state towards your conversation partner into account, they are as follows: " + emotional_relation
	# ^^^ changed it so it only starts updating emotional relation after a threshold has been reached (4 atm). We get more reliable output this way, they hallucinate less. (is changed in Mind.update_or_decide_relation)
	RequestHandlerManager.chat_request(self, mind.dialogue_context, _on_request_completed)

func request_activity(): #used for asking for current activity
	is_thinking = true
	var _message: String = ""
	if(!mind.activity_context.is_empty()):
		_message += "These are the things you were doing previously today:\n"
		_message += "\n" + "\n".join(mind.activity_context)+"\n\n"
	_message += "It's "+str(GameManager.hour)+GameManager.time_of_day+". What are you doing right now based on your Charactertraits? Are you sleeping, working or doing something else? (Answer as monologue)"
	RequestHandlerManager.generate_request(self, _message, _on_request_completed)

func request_choice(): #used for getting a name for who they want to call on the phone (npc2npc)
	is_thinking = true
	is_choosing = true
	var _message: String = "It's "+str(GameManager.hour)+GameManager.time_of_day+". You may call one of your neighbors. You know "+NPCManager.get_npc_list_as_string_without_self(self)+". Who would you like to call? You may not call youself. Answer with just the name of the person you would like to call or just no if you want to call nobody. Example:<Their Name> <Their Surname> (without the brackets)"
	#print(_message)
	RequestHandlerManager.generate_request(self, _message, _on_request_completed)
	#choice_attempts+=1

func _chat_with(_message: String, _npc: NPC):
	#print(_message)
	mind.last_received_Message = _message
	_npc.request_answer(_message)

func _on_conversation_over(_json: Dictionary): #is called in the initiator, handles all cleanup after conversation
	if(is_initiator): #_remove_line2D()
		_remove_arrow()
	is_initiator = false
	print("---------SYSTEM-------- Conversation between "+self.name+" and "+conversation_partner.name+" was identified to be over")
	conversation_partner.conversation_partner = null
	conversation_partner = null
	is_conversation_over = false
	#if get_parent().isConversationSelected:
	hide_chatbox()
	get_parent().isConversationSelected = false
	

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
	
func _add_arrow():
	var _texture = load("res://Assets/long_green_arrow.png") 
	var _arrow: Sprite2D = Sprite2D.new()
	_arrow.texture = _texture
	_arrow.scale = Vector2(0.2,0.2)
	_arrow.position = self.get_child(0).position+(conversation_partner.get_child(0).position - self.get_child(0).position)/2 #habe hier schon get_child(0) probiert, funktioniert leider nicht :(
	_arrow.look_at(conversation_partner.get_child(0).position) #momentan für veranschauung mal get child 0 auf conversation partner, das funktioniert "fast" so wie es soll? Kann ich nicht beurteilen
	_arrow.rotate(PI/2)
	_arrow.name = "Communication Arrow from "+self.name+" to "+conversation_partner.name
	_arrow.material = ShaderMaterial.new()
	var shader = load("res://Scenes/arrows.gdshader")
	_arrow.material.shader = shader
	var _script = load("res://HUD/ArrowScript.gd")
	_arrow.set_script(_script)
	self.add_child(_arrow)
	
func _remove_arrow():
	var _arrow = self.get_node("Communication Arrow from "+self.name+" to "+conversation_partner.name)
	self.remove_child(_arrow)
