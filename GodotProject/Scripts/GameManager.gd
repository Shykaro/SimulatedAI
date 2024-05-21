extends Node

var time_count: int = 0
var hour: int = 8
var time_of_day: String = " pm"
# Called when the node enters the scene tree for the first time.
func _ready():
	var _npc0: NPC = NPCManager.create_npc("Elong Ma", "llama3", Vector2(200,200))
	var _npc1: NPC = NPCManager.create_npc("Marie", "llama3", Vector2(800,400))
	get_tree().get_root().get_node("/root/Game/NPCManager").add_child(_npc0)
	get_tree().get_root().get_node("/root/Game/NPCManager").add_child(_npc1)
	#create_npc("Jeff", "phi", 6,  Vector2(800,200))
	#create_npc("Lara", "phi", 8,  Vector2(200,400))
	#_npc0.check_for_npc_available() #starts test run of conversation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	time_count += 1
	if(time_count==150000000): time_count = 0 #so that int doesnt overflow
	if(time_count%500==0):
		if(check_npcs_thinking()):
			time_count -=1
		else:
			_hourly_event()
		#print(".")
		

func _hourly_event():
	#do something
	print("---------------- "+"It is "+str(hour)+time_of_day+". -------------")
	if(hour==8&&time_of_day==" pm"):
		for _npc: NPC in NPCManager.npc_list:
			_npc.request_choice("You are "+ _npc.name + ". It's "+str(hour)+time_of_day+". You may call one of your neighbors. You know "+NPCManager.get_npc_list_as_string()+". Who would you like to call? Answer with just their name. Example: Name")
	else:
		for _npc: NPC in NPCManager.npc_list:
			_npc.request_answer("You are "+ _npc.name + ". It's "+str(hour)+time_of_day+". What are you doing right now? Are you sleeping, working or doing something else?")
	
	increment_time()

func check_npcs_thinking():
	var is_anyone_thinking: bool = false
	for _npc: NPC in NPCManager.npc_list:
		if(_npc.is_thinking): is_anyone_thinking = true
	return is_anyone_thinking
	
func increment_time():
	hour += 1
	if(hour==13): 
		hour = 1
		if(time_of_day == " am"): time_of_day = " pm"
		else: time_of_day = " am"
