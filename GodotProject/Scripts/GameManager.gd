extends Node

var time_count: int = 0
var hour: int = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	var _npc0: NPC = NPCManager.create_npc("Elong Ma", "llama3", Vector2(200,200))
	var _npc1: NPC = NPCManager.create_npc("Marie", "llama3", Vector2(800,400))
	get_tree().get_root().get_node("/root/Game/NPCManager").add_child(_npc0)
	get_tree().get_root().get_node("/root/Game/NPCManager").add_child(_npc1)
	#create_npc("Jeff", "phi", 6,  Vector2(800,200))
	#create_npc("Lara", "phi", 8,  Vector2(200,400))
	_npc0.check_for_npc_available() #starts test run of conversation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_count += 1
	if(time_count==150000000): time_count = 0 #so that int doesnt overflow
	if(time_count%500==0):
		_hourly_event()
		#print(".")
		

func _hourly_event():
	#do something
	#for _npc: NPC in NPCManager.npc_list:
		#_npc.request_answer("You are "+ _npc.name + ". It's "+str(hour)+"o'clock. What are you doing right now?")
	hour += 1
	if(hour==25): hour = 1
	pass
