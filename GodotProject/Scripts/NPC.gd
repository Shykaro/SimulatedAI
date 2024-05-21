extends Node

class_name NPC

@export var id: int
var associated_llm: String
var conversation_partner: NPC

var is_thinking: bool = false
var is_choosing: bool = false
#var timeout_interval: int = 10
# Called when the node enters the scene tree for the first time.
func start():
	#assert(id != null, "WARNING: NPC instance has no id!") this can be used to debug (basically, if then print)
	id = NPCManager.npc_list.size()

func check_for_npc_available(): 
	#try to establish communication with another NPC
		for i in range(NPCManager.npc_list.size()): #Goes through all npcs
			_establish_communication(NPCManager.npc_list[i])
			break

func _establish_communication(_npc: NPC): #To use for npc to npc conversation
	if(conversation_partner == null):#if not talking
		if(_npc.id != self.id): #if the other npc it not self
			if(_npc.conversation_partner == null): # and the other is not talking
				conversation_partner = _npc
				conversation_partner.conversation_partner = self
				_add_line2D() #adds line from self to conversation partner
				var init_message = "You meet "+conversation_partner.name+". You are "+name+". You have apples on your mind. What do you say? One sentence"
				request_answer(init_message)

func _on_request_completed(_request_handler: RequestHandler, _dict: Dictionary):
	is_thinking = false
	var reply_string: String = _dict["message"]["content"]
	print(self.name+":")
	print(reply_string)
	print()
	if(conversation_partner!=null): _chat_with(reply_string, conversation_partner)
	if(is_choosing):
		for _npc: NPC in NPCManager.npc_list:
			if(_npc.name == reply_string): 
				is_choosing = false
				_establish_communication(_npc)
		if(conversation_partner==null): print("No NPC was chosen")
		is_choosing = false
	
func request_answer(_message: String): #sends a request to own LLM
	is_thinking = true
	RequestHandlerManager.start_request(self, _message)

func request_choice(_message: String):
	is_thinking = true
	is_choosing = true
	RequestHandlerManager.start_request(self, _message)

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
	_line.add_point(conversation_partner.position-self.position)
	_line.name = "Communication Line between "+self.name+" and "+conversation_partner.name
	self.add_child(_line)
	_line.default_color = Color("red")

func _remove_line2D():
	var _line = self.get_node("Communication Line between "+self.name+" and "+conversation_partner.name)
	self.remove_child(_line)


# Step 1: NPC A asks LLM A what it should say
# Step 2: NPC A retrieves answer from LLM A
# Step 3: NPC A sends message to NPC B
# Step 4: NPC B sends LLM B message of NPC A
# Step 5: NPC B retrieves answer from LLM B
# Step 6: NPC B sends message to NPC A
