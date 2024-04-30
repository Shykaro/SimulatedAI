extends Node

class_name NPCManager

static var npc_list: Array = []
static var npc_tree_scene: PackedScene

static func get_npc_by_id(_id: int):
	for i in range(npc_list.size()):
		if(npc_list[i].id == _id):
			return npc_list[i]

func create_npc(_given_name: String, _given_llm: String, _given_chat_interval: int):
	var _npc: NPC = npc_tree_scene.instantiate()
	_npc.name = _given_name
	_npc.associated_llm = _given_llm
	_npc.chat_interval = _given_chat_interval
	npc_list.append(_npc)
	self.add_child(_npc)
	_npc.start()

func _ready():
	print("DEBUG: instantiating NPCs...")
	npc_tree_scene = preload("res://Scenes/npc_tree.tscn")
	create_npc("Elong Ma", "Starlink",10)
	create_npc("bruh", "bruh",3)
	print(npc_list)

