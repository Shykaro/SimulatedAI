extends Node

class_name NPC

@export var id: int
var associated_llm: String
var chat_interval: int
var is_talking: bool = false
var communication_line: Line2D = Line2D.new()
var timer = Timer.new()
var timeout_interval: int = 10
# Called when the node enters the scene tree for the first time.
func start():
	#assert(id != null, "WARNING: NPC instance has no id!") this can be used to debug (basically, if then print)
	id = NPCManager.npc_list.size()
	self.add_child(communication_line)
	communication_line.default_color = Color("red")
	timer.timeout.connect(_on_timer_timeout)
	self.add_child(timer)
	timer.start(chat_interval)

func _on_timer_timeout():
	#print("id "+str(id)+" timeout!")
	#try to establish communication with another NPC
	if(!self.is_talking):
		for i in range(NPCManager.npc_list.size()):
			if(NPCManager.npc_list[i].id != self.id):
				if(!NPCManager.npc_list[i].is_talking):
					_establish_communication(NPCManager.npc_list[i])
					break
	else:
		print(self.name+"'s chat timed out")
		timer.stop()
		_on_conversation_over()
		timer.start(chat_interval)
	
#func _process(delta):
#	if(is_talking): timer.stop()

func _establish_communication(_npc: NPC):
	timer.start(timeout_interval)
	_npc.is_talking = true
	#_npc.timer.stop()
	is_talking = true
	communication_line.add_point(Vector2.ZERO)
	communication_line.add_point(_npc.position-self.position)
	print(self.name+" is talking to "+_npc.name)
	var request_handler: RequestHandler = RequestHandler.new()
	self.add_child(request_handler)
	request_handler.request_processed.connect(_on_conversation_over)
	request_handler.chat("Hello, I am "+name)
	
func _on_conversation_over():
	is_talking = false
	communication_line.clear_points()
	print("bye!")
	
	
