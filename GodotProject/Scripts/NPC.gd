extends Node

class_name NPC

@export var id: int
var associated_llm: String
var conversation_partner: NPC
var request_handler: RequestHandler
#var timeout_interval: int = 10
# Called when the node enters the scene tree for the first time.
func start():
	#assert(id != null, "WARNING: NPC instance has no id!") this can be used to debug (basically, if then print)
	id = NPCManager.npc_list.size()

func _on_timer_timeout():
	#try to establish communication with another NPC
	if(conversation_partner == null): #if not talking
		for i in range(NPCManager.npc_list.size()): #Goes through all npcs
			if(NPCManager.npc_list[i].id != self.id): #if the other npc it not self
				if(!NPCManager.npc_list[i].is_talking): # and the other is not talking
					_establish_communication(NPCManager.npc_list[i])
					break

func _establish_communication(_npc: NPC):
	conversation_partner = _npc
	_add_line2D() #adds line from self to conversation partner
	request_handler = RequestHandler.new()
	self.add_child(request_handler)
	request_handler.request_processed.connect(_on_reply_received) #to be placed into "the other" npc
	var init_message = "You meet "+_npc.name+". You are "+name+". What do you say? One sentence"
	print(init_message)
	request_handler.chat(init_message, associated_llm) #to LLM 1

func _on_reply_received(json: Dictionary):
	var reply_string: String = json["message"]["content"]
	var model_used: String = json["model"]
	print(model_used+": "+reply_string)
	request_handler.chat(reply_string, conversation_partner.associated_llm) #to LLM 2

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
	
	
	
	
