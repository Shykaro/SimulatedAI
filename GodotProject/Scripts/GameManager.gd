extends Node

class_name GameManager

var time_count: int = 0
static var hour: int = 8
static var time_of_day: String = " pm"
# Called when the node enters the scene tree for the first time.
func _ready():
	NPCManager.create_npc("Maike Klein", "Maike", Vector2(200,200))
	NPCManager.create_npc("Gustavo Silva", "Gustavo", Vector2(800,400))
	NPCManager.create_npc("Maike Groß", "Maike", Vector2(400,200))
	NPCManager.create_npc("Gustavo Golda", "Gustavo", Vector2(600,400))
	NPCManager.create_npc("Maike Medium", "Maike", Vector2(200,400))
	NPCManager.create_npc("Gustavo Platina", "Gustavo", Vector2(800,600))
	NPCManager.create_npc("Maike Winzig", "Maike", Vector2(400,400))
	NPCManager.create_npc("Gustavo Bonza", "Gustavo", Vector2(600,600))
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
			_npc.request_choice()
	else:
		for _npc: NPC in NPCManager.npc_list:
			_npc.request_answer("It's "+str(hour)+time_of_day+". What are you doing right now? Are you sleeping, working or doing something else?")
	
	increment_time()

func check_npcs_thinking():
	var is_anyone_thinking: bool = false
	for _npc: NPC in NPCManager.npc_list:
		if(_npc.is_thinking): is_anyone_thinking = true
	return is_anyone_thinking
	
func increment_time():
	hour += 1
	if(hour==12): 
		if(time_of_day == " am"): time_of_day = " pm"
		else: time_of_day = " am"
	if(hour==13): hour=1
