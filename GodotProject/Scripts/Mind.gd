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

func reflect_on_day():
	pass

func check_conversation_over():
	var dialogue_context_string_array = get_dialogue_context_as_string_array()
	var _message: String = "You are having this conversation: \n"
	_message += "\n"+"\n".join(dialogue_context_string_array) #adds every entry in dialogue to string
	_message += "\n\n Do you think it's over? Have both said their farewells? If yes, just answer yes. If no, answer with no only"
	#print(_message) #includes all conversation and instructions to choose yes or no
	RequestHandlerManager.request_check_conversation_over(associated_npc, _message)

func _on_request_conversation_over_completed(_request_handler: RequestHandler, _dict: Dictionary):
	var reply_string: String = _dict["response"]
	print(reply_string)
	if(reply_string == "yes" or reply_string == "Yes"):
		associated_npc.is_conversation_over = true

func update_emotional_state(_what_just_happened: String):
	var _message: String = "Before doing "+_what_just_happened+"you felt like this: "+emotional_state+". How do you feel now? Describe your emotional state in one word only."
	RequestHandlerManager.request_emotional_state_update(associated_npc, _message)

func _on_request_emotional_state_complete(_request_handler: RequestHandler, _dict: Dictionary):
	var reply_string: String = _dict["response"]
	emotional_state = reply_string

func get_dialogue_context_as_string_array():
	var dialogue_context_string_array: Array[String] = []
	for entry:Dictionary in dialogue_context:
		dialogue_context_string_array.append(entry["content"])
	return dialogue_context_string_array

func clear():
	dialogue_context.clear()


#func save_conversation_with(_conversation, _npc):
	#var _npc_id: int = conversations.find(_npc)
	#conversations[_npc_id].append(_conversation)
	#var file = FileAccess.open(path, FileAccess.WRITE)
	#file.store_string(JSON.stringify(_conversation))
	#file.close()

#func summarize_conversation(_conversation):
	## Zusammenfassungslogik hierher
	#var summary = "" 
	#return summary

#func summarize_all_conversations_with(_npc):
	#var _npc_id: int = conversations.find(_npc)
	#for conv in conversations[_npc_id]:
		#overall_summary += summarize_conversation(conv) + "\n"


#var conversation_A1 = "Dies ist das erste Gespräch mit A."
#var conversation_A2 = "Dies ist das zweite Gespräch mit A."
#var conversation_B1 = "Dies ist das erste Gespräch mit B."
