var json = JSON.new()
var path = "user://data.JSON"

var mind_name : String = ""
var conversations:Array[Array]
var overall_summary : String
var associated_llm: String

func _init(name):
	self.mind_name = name

func save_conversation_with(_conversation, _npc):
	var _npc_id: int = conversations.find(_npc)
	conversations[_npc_id].append(_conversation)
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(json.stringify(_conversation))
	file.close()

func summarize_conversation(conversation):
	# Zusammenfassungslogik hierher
	var summary = "" 
	return summary

func summarize_all_conversations_with(_npc):
	var _npc_id: int = conversations.find(_npc)
	for conv in conversations[_npc_id]:
		overall_summary += summarize_conversation(conv) + "\n"


var conversation_A1 = "Dies ist das erste Gespräch mit A."
var conversation_A2 = "Dies ist das zweite Gespräch mit A."
var conversation_B1 = "Dies ist das erste Gespräch mit B."
