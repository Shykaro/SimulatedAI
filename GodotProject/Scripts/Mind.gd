extends Node

class_name Mind

#var json = JSON.new()
#var path = "user://data.JSON"
#var conversations: Array[Array]
#var overall_summary : String
var associated_llm: String
var activity_context: Array[String]
var dialogue_context: Array[Dictionary]
var emotional_state: String = "content"
var associated_npc: NPC
#var conversation_partner: NPC
#var conversation_partner_npc: NPC #current_or_last
var long_term_storage: Array[String]
var emotional_relations: Dictionary = {} # possibility (String) saved under emotional_relations[npcname]
var pic_scale_values: Dictionary
var pic_scale_possibilities: Array[String] = ["distant","neither close nor distant","a little bit close","moderately close","very close","fully close"]
var pic_scale_values_history: Dictionary # npcname->day->index example: pic_scale_values_history["Alexander Gassner"][2][10] (The tenth update to Alexander Gassners relation value on the second day )
var number_of_pic_scale_values_on_day: int = 0
#func update_conversation_partner(ConversationpartnerNPC): #last or current
	#conversation_partner = ConversationpartnerNPC
	#print("Current conversation partner for " + associated_npc.name + " is: " + conversation_partner.name)

func init_pic_scale_values():
	for _npc in NPCManager.npc_list:
		pic_scale_values[_npc.name] = "distant" #initializes all other npcs as distant
		pic_scale_values_history[_npc.name] = {}#array within array to house index in noOfDay
		#print("CREATED ARRAYS")
	pic_scale_values[associated_npc.name] = "yourself"

func reflect_on_day(): #this is where the long term memories are stored (Happens while they "sleep" (dont mind the humanitization))
	#TODO for another day/project: Make the requests asynchronous and await them. This way, we have less code and no tasks are done before the prerequisites
	#LT = (condensed activity, condensed dialogue, emotional state, emotional context (for each npc))
	var _message: String
	_message = "This is what you did today: \n"
	_message += "\n".join(activity_context)+"\n\n"
	_message += "This is how your conversation of the day went: \n"
	_message += "\n".join(dialogue_context)+"\n\n"
	_message += "This is how youre feeling right now: \n"
	_message += emotional_state+"\n\n"
	_message += "This is how youre feeling about every other neighbor: \n"
	_message += "\n".join(get_labled_emotional_relations_string_array())+"\n\n"
	_message += "Out of all these experiences, choose the ones that were the most memorable and important. Make a bullet list with a couple entries."
	RequestHandlerManager.generate_request(associated_npc, _message, _on_request_reflect_on_day)
	activity_context.clear()
	dialogue_context.clear()
	number_of_pic_scale_values_on_day = 0

func _on_request_reflect_on_day(_request_handler: RequestHandler, _dict: Dictionary):
	var reply_string: String = _dict["response"]
	print("---------SYSTEM-------- STORED LONG TERM MEMORY "+associated_npc.name+": "+reply_string)


func check_conversation_over():
	var cutoff_threshold = 20
	var start_checking_threshold = 4
	if(dialogue_context.size()<start_checking_threshold): return
	if(dialogue_context.size()>cutoff_threshold):
		print("---------SYSTEM-------- Conversation was cut, cutoff threshold surpassed (It is 9 pm)")
		associated_npc.is_conversation_over = true
		return
	var dialogue_context_string_array = get_dialogue_context_as_string_array()
	var _message: String = "You are having this conversation: \n"
	_message += "\n"+"\n".join(dialogue_context_string_array) #adds every entry in dialogue to string
	_message += "\n\n Has your counterpart said their farewells just now and would you like to end the conversation? If yes, ONLY answer yes. If no, answer with ONLY no"
	#print(_message) #includes all conversation and instructions to choose yes or no
	RequestHandlerManager.generate_request(associated_npc, _message, _on_request_conversation_over_completed)

func _on_request_conversation_over_completed(_request_handler: RequestHandler, _dict: Dictionary):
	var reply_string: String = _dict["response"]
	#print(reply_string)
	if(reply_string == "yes" or reply_string == "Yes"):
		associated_npc.is_conversation_over = true

func update_emotional_state(_what_just_happened: String):
	var _message: String = "Before doing "+_what_just_happened+"you felt like this: "+emotional_state+". How do you feel now? Describe your emotional state in one very short sentence only."
	RequestHandlerManager.generate_request(associated_npc, _message, _on_request_emotional_state_complete)

func _on_request_emotional_state_complete(_request_handler: RequestHandler, _dict: Dictionary):
	var reply_string: String = _dict["response"]
	emotional_state = reply_string

func condense_dialogue():
	var _message: String = ""
	var dialogue_context_as_string_array: Array[String] = get_dialogue_context_as_string_array()
	_message += "This is how your conversation of the day went:\n"
	_message += "\n" + "\n".join(dialogue_context_as_string_array)+"\n\n"
	_message += "What are the most important pieces of informations that you should remember for the coming days? Condense it down intro two sentences total."
	RequestHandlerManager.generate_request(associated_npc, _message, _on_request_condense_dialogue_completed)

func _on_request_condense_dialogue_completed(_request_handler: RequestHandler, _dict: Dictionary): # for some reason never happens
	var reply_string: String = _dict["response"]
	dialogue_context.clear()
	dialogue_context.append(reply_string)
	print("---------SYSTEM-------- Condensed conversation for someone!") #lol

func condense_activity():
	var _message: String = ""
	if(!activity_context.is_empty()):
		_message += "These are the things you were doing previously today:\n"
		_message += "\n" + "\n".join(activity_context)+"\n\n"
	_message += "Condense your day down into two sentences total."
	RequestHandlerManager.generate_request(associated_npc, _message, _on_request_condense_activity_completed)
	
func _on_request_condense_activity_completed(_request_handler: RequestHandler, _dict: Dictionary):
	var reply_string: String = _dict["response"]
	activity_context.clear()
	activity_context.append(reply_string)

# ////////////////////////////// Emotional Relation Stuff Anfang //////////////////////////////

#get_emotional_relation muss noch einen Punkt zum einfügen finden? Bevor ein Anruf getätigt wird, wenn ein Anruf getätigt wird??...
func get_emotional_relation(conversation_partner_npc_name: String): #1.1 get line
	if conversation_partner_npc_name in emotional_relations:
		return emotional_relations[conversation_partner_npc_name]
	return #returns null if none is found

func update_relation_during_conversation(npc: NPC, message: String): #1 von NPC
	var start_checking_threshold = 4
	if(dialogue_context.size()<start_checking_threshold): return
	update_or_decide_relation(npc, message)

func update_or_decide_relation(npc: NPC, message: String, context: String = ""): #2 von update_relation_during_conversation !!! -> npc parameter kann vlt neglected werden, wurde durch associated_npc.conversation_partner.name ersetzt
	var _message: String
	if context == "":
		_message = "Based on the following message:\n" + message
	else:
		_message = "Based on the following conversation:\n" + context + "\n" + message
	_message += "\n\n How do you (" + associated_npc.name + ") feel about your relationship with " + npc.name + " now? Please describe it in one sentence."
	RequestHandlerManager.generate_request(associated_npc, _message, _on_request_update_relation_completed) #changed to associated, because if npc is passed, the relation will be written in the storage of the conversation partner

func _on_request_update_relation_completed(_request_handler: RequestHandler, _dict: Dictionary): #4 wartet auf requesthandlerManagerLLM answer
	var reply_string: String = _dict["response"]
	set_emotional_relation(associated_npc.conversation_partner.name, reply_string)
	update_pic_scale_value(associated_npc.conversation_partner.name, reply_string)
	update_relation_file(associated_npc.name+"->"+associated_npc.conversation_partner.name+": "+reply_string)
	#print("\n" + "\n" + "Updated relation with " + associated_npc.conversation_partner.name + ": " + reply_string )

func update_pic_scale_value(_npc_name: String, _relation: String):
	if(emotional_relations[_npc_name]==null): return
	var _message: String = ""
	_message += "This is your current relation to "+ _npc_name+": "+emotional_relations[_npc_name]
	_message += "\n\n"+"Feeling close refers to being listened to, understood by, able to share feelings and to talk openly with another person. Rate the persons after each talk into one of the listed categories down below. Imagine it like an Onion or multiple circles lying inside each other. You are in the middle, represented by “yourself”, then follows “fully close”, “very close” and so on, the furthest layer is “distant”. The “distant” category includes people with whom you have never interacted or from whom you have not received additional information from a third party."
	_message += "\n\n"+"ONLY answer with one of the following words depending on your relationship (and nothing else):"
	_message += "\n".join(pic_scale_possibilities)
	RequestHandlerManager.generate_request(associated_npc, _message, _on_request_update_pic_scale_value_completed)

func _on_request_update_pic_scale_value_completed(_request_handler: RequestHandler, _dict: Dictionary): #4 wartet auf requesthandlerManagerLLM answer
	var reply_string: String = _dict["response"]
	var _answer: String
	for possibility: String in pic_scale_possibilities:
		if(reply_string.contains(possibility)): _answer = possibility
	if(_answer!=null): 
		pic_scale_values[associated_npc.last_conversation_partner.name] = _answer
		number_of_pic_scale_values_on_day += 1
		_set_pic_scale_values_history(_answer)
	else: print("---------WARNING-------- "+ associated_npc.name+" gave no valid pic scale answer for "+associated_npc.last_conversation_partner.name)
	#print("\n" + "\n" + "Updated relation with " + associated_npc.conversation_partner.name + ": " + reply_string )

func _set_pic_scale_values_history(_answer:String):
	#var my_dict = {
	#	"Alex": {1:{1:"distant",2:"close"},2:{1:"close",2:"relatively close"}},
	#	"Maike": {} #same
	#	}
	var personal_dict: Dictionary = pic_scale_values_history[associated_npc.last_conversation_partner.name]
	if(!personal_dict.keys().has(GameManager.day_number)):
		personal_dict[GameManager.day_number] = {number_of_pic_scale_values_on_day: _answer}
	else:
		personal_dict[GameManager.day_number][number_of_pic_scale_values_on_day] = _answer


#set_emotional_relation("Gustavo", "For some reason, I feel anger towards Gustavo")
#Missing the possibility to change relation according to the relation it had before (is that already considered in the initail prompt?)
func set_emotional_relation(npc_name: String, relation: String): #5 wird gesetzt von _on_request_update_relation_completed
	#print(relation)
	emotional_relations[npc_name] = relation

func get_labled_emotional_relations_string_array():
	var labled_emotional_relations_string_array: Array[String] = []
	for _npc in NPCManager.npc_list:
		if(_npc.name!=associated_npc.name):
			if(emotional_relations[_npc.name]!=null):
				labled_emotional_relations_string_array.append(_npc.name+": "+emotional_relations[_npc.name])
	return labled_emotional_relations_string_array
# ////////////////////////////// Emotional Relation Stuff ENDE //////////////////////////////

func get_dialogue_context_as_string_array():
	var dialogue_context_string_array: Array[String] = []
	for entry:Dictionary in dialogue_context:
		var labled_entry: String
		if(entry["role"]=="assistant"):labled_entry = "You: "
		else: labled_entry = associated_npc.last_conversation_partner.name+": "
		labled_entry += entry["content"]
		dialogue_context_string_array.append(labled_entry)
	return dialogue_context_string_array

func update_relation_file(content: String):
	var previous_content: String = get_from_relation_file()
	#print("PREVIOUSLY: "+previous_content)
	save_to_relation_file(previous_content+"\n\n"+content)

func save_to_relation_file(content: String):
	var fileWrite = FileAccess.open("res://Assets/relation.txt", FileAccess.WRITE)
	fileWrite.store_string(content)

func get_from_relation_file() -> String:
	var file = FileAccess.open("res://Assets/relation.txt", FileAccess.READ)
	var content: String = file.get_as_text()
	return content

#func _ready(): #@ALEX: brauchst du das noch? Wenn nicht, bitte löschen
	#set_emotional_relation("Maike", "I am feeling confident in my relationship to Maike, since she told me that she liked me")
	#set_emotional_relation("Gustavo", "For some reason, I feel anger towards Gustavo")
	#print(get_emotional_relation("Maike")) # Erwartete Ausgabe: I am feeling confident in my relationship to Maike, since she told me that she liked me
	#print(get_emotional_relation("Gustavo")) # Erwartete Ausgabe: For some reason, I feel anger towards Gustavo
	#print(get_emotional_relation("Unknown")) # Erwartete Ausgabe: No emotional context found for Unknown
