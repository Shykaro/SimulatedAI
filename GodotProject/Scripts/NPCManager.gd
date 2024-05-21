extends Node

class_name NPCManager

static var npc_list: Array = []
static var npc_scene: PackedScene

func _ready():
	print("DEBUG: instantiating NPCs...")
	npc_scene = load("res://Scenes/npc.tscn")

static func get_npc_by_id(_id: int):
	for i in range(npc_list.size()):
		if(npc_list[i].id == _id):
			print(npc_list[i].name)
			return npc_list[i]

static func create_npc(_given_name: String, _given_llm: String, _given_position: Vector2):
	var _npc: NPC = npc_scene.instantiate()
	_npc.name = _given_name
	_npc.associated_llm = _given_llm
	npc_list.append(_npc)
	_npc.position = _given_position
	_npc.start()
	return _npc

static func get_npc_list_as_string():
	var list_as_string: String = ""
	for _npc: NPC in NPCManager.npc_list:
		if(list_as_string==""): list_as_string+=_npc.name
		list_as_string+=", "+_npc.name
	return list_as_string

