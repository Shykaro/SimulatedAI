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

var emotional_relations: Dictionary = {}

#func update_conversation_partner(ConversationpartnerNPC): #last or current
	#conversation_partner = ConversationpartnerNPC
	#print("Current conversation partner for " + associated_npc.name + " is: " + conversation_partner.name)

func reflect_on_day(): #this is where the long term memories are stored (Happens while they "sleep" (dont mind the humanitization))
	
	pass

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
	var _message: String = "Before doing "+_what_just_happened+"you felt like this: "+emotional_state+". How do you feel now? Describe your emotional state in one word only."
	RequestHandlerManager.generate_request(associated_npc, _message, _on_request_emotional_state_complete)

func _on_request_emotional_state_complete(_request_handler: RequestHandler, _dict: Dictionary):
	var reply_string: String = _dict["response"]
	emotional_state = reply_string

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

	_message += "\n\n How do you (" + associated_npc.name + ") feel about your relationship with " + associated_npc.conversation_partner.name + " now? Please describe it in one sentence."
	RequestHandlerManager.generate_request(npc, _message, _on_request_update_relation_completed)
	
func _on_request_update_relation_completed(_request_handler: RequestHandler, _dict: Dictionary): #4 wartet auf requesthandlerManagerLLM answer
	var reply_string: String = _dict["response"]
	set_emotional_relation(associated_npc.conversation_partner.name, reply_string)
	save_to_relation_file(associated_npc.name+"->"+associated_npc.conversation_partner.name+": reply_string")
	#print("\n" + "\n" + "Updated relation with " + associated_npc.conversation_partner.name + ": " + reply_string )
	
#set_emotional_relation("Gustavo", "For some reason, I feel anger towards Gustavo")
#Missing the possibility to change relation according to the relation it had before (is that already considered in the initail prompt?)
func set_emotional_relation(npc_name: String, relation: String): #5 wird gesetzt von _on_request_update_relation_completed
	#print(relation)
	emotional_relations[npc_name] = relation

# ////////////////////////////// Emotional Relation Stuff ENDE //////////////////////////////

func get_dialogue_context_as_string_array():
	var dialogue_context_string_array: Array[String] = []
	for entry:Dictionary in dialogue_context:
		dialogue_context_string_array.append(entry["content"])
	return dialogue_context_string_array

func save_to_relation_file(content):
	var file = FileAccess.open("res://Assets/relation.txt", FileAccess.WRITE)
	file.store_string("\n\n"+content)


#func _ready(): #@ALEX: brauchst du das noch? Wenn nicht, bitte löschen
	#set_emotional_relation("Maike", "I am feeling confident in my relationship to Maike, since she told me that she liked me")
	#set_emotional_relation("Gustavo", "For some reason, I feel anger towards Gustavo")
	#print(get_emotional_relation("Maike")) # Erwartete Ausgabe: I am feeling confident in my relationship to Maike, since she told me that she liked me
	#print(get_emotional_relation("Gustavo")) # Erwartete Ausgabe: For some reason, I feel anger towards Gustavo
	#print(get_emotional_relation("Unknown")) # Erwartete Ausgabe: No emotional context found for Unknown
