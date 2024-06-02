extends Node

class_name RequestHandlerManager

static var instance: RequestHandlerManager 
static var request_handler_list: Array = []

func _ready():
	instance = self

static func request_chat_api(_npc: NPC, _messages: Array):
	var associated_llm = _npc.associated_llm
	var _request_handler: RequestHandler = RequestHandler.new()
	instance.add_child(_request_handler)
	_request_handler.request_processed.connect(_npc._on_request_completed)
	_request_handler.request_processed.connect(instance._delete_request_handler)
	_request_handler.chat(_messages, associated_llm)
	request_handler_list.append(_request_handler)

static func request_generate_api(_npc: NPC, _message: String):
	var associated_llm = _npc.associated_llm
	var _request_handler: RequestHandler = RequestHandler.new()
	instance.add_child(_request_handler)
	_request_handler.request_processed.connect(_npc._on_request_completed)
	_request_handler.request_processed.connect(instance._delete_request_handler)
	_request_handler.generate(_message, associated_llm)
	request_handler_list.append(_request_handler)

static func _delete_request_handler(_request_handler: RequestHandler, _dict: Dictionary):
	for request_handler in request_handler_list:
		if(request_handler == _request_handler):
			instance.remove_child(request_handler)
