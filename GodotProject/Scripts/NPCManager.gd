extends Node

class_name NPCManager
#Manages all npcs... I think the functions are self-explanatory
static var instance: NPCManager
static var npc_list: Array = []
static var npc_scene: PackedScene
var isNPCselected = false
var isConversationSelected = false


func _ready():
	instance = self
	print("DEBUG: instantiating NPCs...")
	npc_scene = load("res://Scenes/npc.tscn")
	#print(get_children())

static func get_npc_by_id(_id: int):
	for i in range(npc_list.size()):
		if(npc_list[i].id == _id):
			print(npc_list[i].name)
			return npc_list[i]

static func create_npc(_given_name: String, _given_llm: String, _given_position: Vector2):
	var _npc: NPC = npc_scene.instantiate()
	instance.add_child(_npc)
	_npc.name = _given_name
	_npc.associated_llm = _given_llm
	npc_list.append(_npc)
	_npc.get_child(0).position = _given_position #changed this to an inbetween node, so root doesnt get played with transformwise
	_npc.start()
	#print(_npc.get_children()) to check NPC hierarchy
	return _npc

static func get_npc_list_as_string():
	var list_as_string: String = ""
	var shuffled_npc_list: Array = npc_list.duplicate()
	shuffled_npc_list.shuffle()
	for _npc_in_list: NPC in shuffled_npc_list:
		if(list_as_string==""): list_as_string+=_npc_in_list.name
		list_as_string+=", "+_npc_in_list.name
	return list_as_string

static func get_npc_list_as_string_without_self(_npc):
	var list_as_string: String = ""
	var shuffled_npc_list: Array = npc_list.duplicate()
	shuffled_npc_list.shuffle()
	for _npc_in_list: NPC in shuffled_npc_list:
		if(_npc_in_list!=_npc):
			if(list_as_string==""): list_as_string+=_npc_in_list.name
			else: list_as_string+=", "+_npc_in_list.name
	return list_as_string


