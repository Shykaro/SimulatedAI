extends Node

class_name NPCManager

static var npc_list: Array = []
static var npc_scene: PackedScene

func _ready():
	print("DEBUG: instantiating NPCs...")
	npc_scene = load("res://Scenes/npc.tscn")
	create_npc("Elong Ma", "phi", Vector2(200,200))
	#create_npc("Jeff", "phi", 6,  Vector2(800,200))
	#create_npc("Lara", "phi", 8,  Vector2(200,400))
	create_npc("Marie", "starling-lm", Vector2(800,400))
	print(npc_list)

static func get_npc_by_id(_id: int):
	for i in range(npc_list.size()):
		if(npc_list[i].id == _id):
			return npc_list[i]

func create_npc(_given_name: String, _given_llm: String, _given_position: Vector2):
	var _npc: NPC = npc_scene.instantiate()
	_npc.name = _given_name
	_npc.associated_llm = _given_llm
	npc_list.append(_npc)
	_npc.position = _given_position
	self.add_child(_npc)
	_npc.start()



