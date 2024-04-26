extends Node

class_name NPC

@export var id: int
# Called when the node enters the scene tree for the first time.
func _ready():
	#assert(id != null, "WARNING: NPC instance has no id!") this can be used to debug (basically, if then print)
	id = NPCManager.npc_list.size()
	NPCManager.add_npc_to_list(self)
