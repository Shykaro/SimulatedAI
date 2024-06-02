extends Node

class_name Mind

#var json = JSON.new()
#var path = "user://data.JSON"
#var conversations: Array[Array]
#var overall_summary : String
var associated_llm: String
var activity_context: Array[String]
var dialogue_context: Array[Dictionary]

func reflect_on_day():
	pass

func check_conversation_over():
	var dialogue_context_string_array = get_dialogue_context_as_string_array()
	var _message: String = "You are having this conversation: \n"
	_message += "\n"+"\n".join(dialogue_context_string_array) #adds every entry in dialogue to string
	_message += "\n\n Do you think it's over? If yes, just answer yes. If no, answer with no only"
	print(_message) #seems to work, now must be actually sent to ollama and response gotten. (generate api)
	
	
	

func add_to_dialogue_context(_message: String):
	dialogue_context.append({"role": "user", "content": _message})

func get_dialogue_context_as_string_array():
	var dialogue_context_string_array: Array[String]
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
