extends Node

class_name NPC

@export var id: int
var associated_llm: String
var conversation_partner: NPC
var request_handler: RequestHandler = RequestHandler.new()
#var timeout_interval: int = 10
# Called when the node enters the scene tree for the first time.
func start():
	#assert(id != null, "WARNING: NPC instance has no id!") this can be used to debug (basically, if then print)
	id = NPCManager.npc_list.size()
	self.add_child(request_handler)
	request_handler.request_processed.connect(_on_reply_received)

func check_for_npc_available(): 
	#try to establish communication with another NPC
	if(conversation_partner == null): #if not talking
		for i in range(NPCManager.npc_list.size()): #Goes through all npcs
			if(NPCManager.npc_list[i].id != self.id): #if the other npc it not self
				if(NPCManager.npc_list[i].conversation_partner == null): # and the other is not talking
					_establish_communication(NPCManager.npc_list[i])
					break

func _establish_communication(_npc: NPC):
	conversation_partner = _npc
	conversation_partner.conversation_partner = self
	_add_line2D() #adds line from self to conversation partner
	var init_message = "You meet "+conversation_partner.name+". You are "+name+". You have apples on your mind. What do you say? One sentence"
	request_answer(init_message)

func _on_reply_received(json: Dictionary):
	var reply_string: String = json["message"]["content"]
	print(self.name+":")
	print(reply_string)
	print()
	_chat_with(reply_string, conversation_partner)
	
func request_answer(_message: String):
	request_handler.chat(_message, associated_llm) # to own LLM

func _chat_with(_message: String, _npc: NPC):
	_npc.request_answer(_message)

func _on_conversation_over(json: Dictionary):
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
	
	
