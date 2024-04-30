extends Node

class_name NPCManager

static var npc_list: Array = []
static var npc_tree_scene: PackedScene

static func get_npc_by_id(_id: int):
	for i in range(npc_list.size()):
		if(npc_list[i].id == _id):
			return npc_list[i]

func create_npc(_given_name: String, _given_llm: String):
	var _npc: NPC = npc_tree_scene.instantiate()
	_npc.name = _given_name
	_npc.associated_llm = _given_llm
	npc_list.append(_npc)
	self.add_child(_npc)

func _ready():
	print("DEBUG: instantiating NPCs...")
	npc_tree_scene = preload("res://Scenes/npc_tree.tscn")
	create_npc("Elong Ma", "Starlink")
	create_npc("bruh", "bruh")
	print(npc_list)
