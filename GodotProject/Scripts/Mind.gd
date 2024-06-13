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

var emotional_relations: Dictionary = {}

func reflect_on_day():
	pass

func check_conversation_over():
	var dialogue_context_string_array = get_dialogue_context_as_string_array()
	var _message: String = "You are having this conversation: \n"
	_message += "\n"+"\n".join(dialogue_context_string_array) #adds every entry in dialogue to string
	_message += "\n\n Has your counterpart said their farewells just now and would you like to end the conversation? If yes, ONLY answer yes. If no, answer with ONLY no"
	#print(_message) #includes all conversation and instructions to choose yes or no
	RequestHandlerManager.request_check_conversation_over(associated_npc, _message)

func _on_request_conversation_over_completed(_request_handler: RequestHandler, _dict: Dictionary):
	var reply_string: String = _dict["response"]
	print(reply_string)
	if(reply_string == "yes" or reply_string == "Yes"):
		associated_npc.is_conversation_over = true
		decide_relation(associated_npc)

func update_emotional_state(_what_just_happened: String):
	var _message: String = "Before doing "+_what_just_happened+"you felt like this: "+emotional_state+". How do you feel now? Describe your emotional state in one word only."
	RequestHandlerManager.request_emotional_state_update(associated_npc, _message)

func _on_request_emotional_state_complete(_request_handler: RequestHandler, _dict: Dictionary):
	var reply_string: String = _dict["response"]
	emotional_state = reply_string

func decide_relation(npc: NPC): #Will cause bugs
	var dialogue_context_string_array = get_dialogue_context_as_string_array()
	var _message: String = "Based on the following conversation:\n"
	_message += "\n" + "\n".join(dialogue_context_string_array)
	_message += "\n\n How do you feel about your relationship with " + npc.name + " now? Please describe it in one sentence."
	RequestHandlerManager.request_decide_relation(npc, _message) #the npc passed here should be associated_npc

func condense_activity():
	var _message: String = ""
	if(!activity_context.is_empty()):
		_message += "These are the things you were doing previously today:\n"
		_message += "\n" + "\n".join(activity_context)+"\n\n"
	_message += "Condense your day down into two sentences total."
	RequestHandlerManager.request_condense_activity(associated_npc, _message)
	
func _on_request_condense_activity_completed(_request_handler: RequestHandler, _dict: Dictionary):
	var reply_string: String = _dict["response"]
	activity_context.clear()
	activity_context.append(reply_string)

func _on_request_decide_relation_completed(_request_handler: RequestHandler, _dict: Dictionary):
	var reply_string: String = _dict["response"]
	set_emotional_relation(associated_npc.name, reply_string)

#set_emotional_relation("Gustavo", "For some reason, I feel anger towards Gustavo")
#Missing the possibility to change relation according to the relation it had before (is that already considered in the initail prompt?)
func set_emotional_relation(npc_name: String, relation: String):
	emotional_relations[npc_name] = relation

#get_emotional_relation muss noch einen Punkt zum einfügen finden? Bevor ein Anruf getätigt wird, wenn ein Anruf getätigt wird??...
func get_emotional_relation(npc_name: String) -> String:
	if npc_name in emotional_relations:
		return emotional_relations[npc_name]
	return "No emotional context found for " + npc_name

func get_dialogue_context_as_string_array():
	var dialogue_context_string_array: Array[String] = []
	for entry:Dictionary in dialogue_context:
		dialogue_context_string_array.append(entry["content"])
	return dialogue_context_string_array

func clear():
	dialogue_context.clear()

func update_relation_during_conversation(npc: NPC, message: String):
	var _message: String = "Based on the following message:\n"
	_message += message
	_message += "\n\n How do you feel about your emotional connection with " + npc.name + " right now? Please describe it in one sentence."
	RequestHandlerManager.request_update_relation(npc, _message)
	
func _on_request_update_relation_completed(_request_handler: RequestHandler, _dict: Dictionary):
	var reply_string: String = _dict["response"]
	set_emotional_relation(associated_npc.name, reply_string)
	print("Updated relation with " + associated_npc.name + ": " + reply_string)
	
#func _ready():
	#set_emotional_relation("Maike", "I am feeling confident in my relationship to Maike, since she told me that she liked me")
	#set_emotional_relation("Gustavo", "For some reason, I feel anger towards Gustavo")
	#print(get_emotional_relation("Maike")) # Erwartete Ausgabe: I am feeling confident in my relationship to Maike, since she told me that she liked me
	#print(get_emotional_relation("Gustavo")) # Erwartete Ausgabe: For some reason, I feel anger towards Gustavo
	#print(get_emotional_relation("Unknown")) # Erwartete Ausgabe: No emotional context found for Unknown
