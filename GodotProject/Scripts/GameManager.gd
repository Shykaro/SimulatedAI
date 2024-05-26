extends Node

class_name GameManager

var time_count: int = 0
static var hour: int = 8
static var time_of_day: String = " pm"
# Called when the node enters the scene tree for the first time.
func _ready():
	#NPCManager.create_npc("Maike Klein", "Maike", Vector2(500,200))
	#NPCManager.create_npc("Gustavo Silva", "Gustavo", Vector2(500,800))
	#NPCManager.create_npc("Maike Groß", "Maike", Vector2(200,350))
	#NPCManager.create_npc("Gustavo Golda", "Gustavo", Vector2(200,650))
	NPCManager.create_npc("Maike Medium", "Maike", Vector2(800,350))
	NPCManager.create_npc("Gustavo Platina", "Gustavo", Vector2(800,650))


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
	if((hour==8&&time_of_day==" pm") or (hour==12&&time_of_day==" am")):
		if(hour==8&&time_of_day==" pm"):
			request_npc_choices()
		if(hour==12&&time_of_day==" am"):
			update_npc_minds()
	else:
		request_npc_activities()
	
	increment_time()

func update_npc_minds():
	for _npc: NPC in NPCManager.npc_list:
		_npc.mind.reflect_on_day()

func request_npc_choices():
	for _npc: NPC in NPCManager.npc_list:
		_npc.request_choice() #starts process of choosing, calling and talking to another npc
func request_npc_activities():
	for _npc: NPC in NPCManager.npc_list:
			_npc.request_answer("It's "+str(hour)+time_of_day+". What are you doing right now? Are you sleeping, working or doing something else?")
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
