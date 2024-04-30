extends Node

class_name NPC

@export var id: int
var associated_llm: String
#Called when object is initializing
func _init(given_name:="Jeff", given__llm:="phi"): 
	name = given_name
	associated_llm = given__llm

# Called when the node enters the scene tree for the first time.
func _ready():
	#assert(id != null, "WARNING: NPC instance has no id!") this can be used to debug (basically, if then print)
	id = NPCManager.npc_list.size()
