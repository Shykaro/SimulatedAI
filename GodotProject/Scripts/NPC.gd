extends Node

class_name NPC

@export var id: int
var associated_llm: String
var chat_interval: int

# Called when the node enters the scene tree for the first time.
func start():
	#assert(id != null, "WARNING: NPC instance has no id!") this can be used to debug (basically, if then print)
	id = NPCManager.npc_list.size()
	var timer = Timer.new()
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	self.add_child(timer)
	timer.start(chat_interval)
	print(chat_interval)

func _on_timer_timeout():
	print("id "+str(id)+" timeout!")

