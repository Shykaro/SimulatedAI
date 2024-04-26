extends Node

class_name NPCManager

static var npc_list: Array = []

static func add_npc_to_list(_npc: NPC):
	npc_list.append(_npc)

static func get_npc_by_id(_id: int):
	for i in range(npc_list.size()):
		if(npc_list[i].id == _id):
			return npc_list[i]

func _ready():
	print("DEBUG: instantiating NPCs...")
	var scene = load("res://Scenes/npc_tree.tscn")
	var npc_tree_scene = preload("res://Scenes/npc_tree.tscn")
	self.add_child(npc_tree_scene.instantiate())
	self.add_child(npc_tree_scene.instantiate())
	self.add_child(npc_tree_scene.instantiate())
	print(npc_list)
	
