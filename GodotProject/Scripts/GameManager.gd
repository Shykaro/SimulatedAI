extends Node

class_name GameManager

var count: int = 0
static var hour: int = 7
static var time_of_day: String = " pm"
# Called when the node enters the scene tree for the first time.
func _ready():
	NPCManager.create_npc("Hendrik Rabe", "01_Hendrik", Vector2(500,200))
	NPCManager.create_npc("Hanna Strittmatter", "02_Hanna", Vector2(500,800))
	#NPCManager.create_npc("Gustavo Silva", "03_Gustavo", Vector2(200,350))
	#NPCManager.create_npc("Maike Klein", "04_Maike", Vector2(200,650))
	#NPCManager.create_npc("Alexander Gassner", "05_Alexander", Vector2(800,350))
	#NPCManager.create_npc("Sophia Matthies", "06_Sophia", Vector2(800,650))
	
	
	#NPCManager.create_npc("Hendrik Rabe", "01_Hendrik", Vector2(200,350))
	#NPCManager.create_npc("Hanna Strittmatter", "02_Hanna", Vector2(200,650))
	#NPCManager.create_npc("Gustavo Silva", "03_Gustavo", Vector2(500,800))
	#NPCManager.create_npc("Maike Klein", "04_Maike", Vector2(500,200))
	#NPCManager.create_npc("Alexander Gassner", "05_Alexander", Vector2(500,200))
	#NPCManager.create_npc("Sophia Matthies", "06_Sophia", Vector2(500,800))
	#NPCManager.create_npc("Lisa Steiger", "07_Lisa", Vector2(200,350))
	#NPCManager.create_npc("Antonio Bartel", "08_Antonio", Vector2(200,650))
	#NPCManager.create_npc("Emily Stier", "09_Emily", Vector2(800,350))
	#NPCManager.create_npc("Miguel Berger", "10_Miguel", Vector2(800,350))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta): #If noone is generating anymore, increment time and start event
	count += 1
	if(count==150000000): count = 0 #so that int doesnt overflow
	if(count%100==0):
		if(check_npcs_thinking()):
			count -=5
		else:
			_hourly_event()
		#print(".")

func _hourly_event(): #checks and increments time, starts event fitting time
	#do something
	print("---------------- "+"It is "+str(hour)+time_of_day+". -------------")
	if((hour==8&&time_of_day==" pm") or (hour==12&&time_of_day==" am")):
		if(hour==8&&time_of_day==" pm"):
			request_npc_choices() #basically initiates calls
		if(hour==12&&time_of_day==" am"):
			update_npc_minds() #will be used for reflecting on the day
	else:
		request_npc_activities() #well, requests npc activities
	increment_time() #basically hour = hour + 1

func update_npc_minds():
	for _npc: NPC in NPCManager.npc_list:
		_npc.mind.reflect_on_day()

func request_npc_choices():
	for _npc: NPC in NPCManager.npc_list:
		_npc.request_choice() #starts process of choosing, calling and talking to another npc
func request_npc_activities():
	for _npc: NPC in NPCManager.npc_list:
			_npc.request_activity()
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
