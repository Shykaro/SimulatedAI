extends Node

class_name GameManager

var count: int = 0
static var hour: int = 8
static var time_of_day: String = " am"
static var day_number: int = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	NPCManager.create_npc("Hendrik Rabe", "01_Hendrik", Vector2(488,167))
	NPCManager.create_npc("Hanna Strittmatter", "02_Hanna", Vector2(547,868))
	NPCManager.create_npc("Gustavo Silva", "03_Gustavo", Vector2(150,342))
	NPCManager.create_npc("Maike Klein", "04_Maike", Vector2(160,700))
	NPCManager.create_npc("Alexander Gassner", "05_Alexander", Vector2(857,360))
	NPCManager.create_npc("Sophia Matthies", "06_Sophia", Vector2(890,767))
	
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
	init_npc_minds()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta): #If noone is generating anymore, increment time and start event
	count += 1
	if(count==150000): count = 0 #so that int doesnt overflow
	if(count%100==0):
		if(day_number>28): 
			print("---------SYSTEM-------- "+"Day 28 is over. The simulation ends.")
			OS.kill(OS.get_process_id())
		if(check_npcs_thinking()):
			count -=5
		else:
			_hourly_event()
		#print(".")

func _hourly_event(): #checks and increments time, starts event fitting time
	#do something
	print("---------------- "+"It is "+str(hour)+time_of_day+". ----------------")
	if((hour==8&&time_of_day==" pm") or (hour==12&&time_of_day==" am")):
		if(hour==8&&time_of_day==" pm"):
			condense_activity_contexts()
			request_npc_choices() #basically initiates calls
		if(hour==9&&time_of_day==" pm"):
			condense_dialogue_contexts()
		if(hour==12&&time_of_day==" am"):
			update_npc_minds() #will be used for reflecting on the day
			print("---------SYSTEM-------- This was day "+str(day_number))
	else:
		request_npc_activities() #well, requests npc activities
	increment_time() #basically hour = hour + 1
func init_npc_minds():
	for _npc: NPC in NPCManager.npc_list:
		_npc.mind.init_pic_scale_values()

func condense_activity_contexts():
	for _npc: NPC in NPCManager.npc_list:
		_npc.mind.condense_activity()
func condense_dialogue_contexts():
	for _npc: NPC in NPCManager.npc_list:
		_npc.mind.condense_dialogue()
		
func update_npc_minds():
	for _npc: NPC in NPCManager.npc_list:
		_npc.mind.reflect_on_day()

func request_npc_choices():
	NPCManager.npc_list.pick_random().request_choice() #starts process of choosing, calling and talking to another npc
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
	if(hour==13): 
		if(time_of_day == " am"): 
			day_number+=1
			hour = 8
		else: hour = 1
