extends Node

class_name RequestHandlerManager
#Manages the creation, communication and deletion of request handlers
static var instance: RequestHandlerManager 
static var request_handler_list: Array = []

func _ready():
	instance = self

static func generate_request(_npc: NPC, _message: String, _callable: Callable):
	var associated_llm = _npc.associated_llm
	var _request_handler: RequestHandler = RequestHandler.new()
	instance.add_child(_request_handler)
	_request_handler.request_processed.connect(_callable)
	_request_handler.request_processed.connect(instance._delete_request_handler)
	_request_handler.generate(_message, associated_llm)
	request_handler_list.append(_request_handler)

static func chat_request(_npc: NPC, _messages: Array, _callable: Callable): #chat api uses context and is passed an array
	var associated_llm = _npc.associated_llm
	var _request_handler: RequestHandler = RequestHandler.new()
	instance.add_child(_request_handler)
	_request_handler.request_processed.connect(_callable)
	_request_handler.request_processed.connect(instance._delete_request_handler)
	_request_handler.chat(_messages, associated_llm)
	request_handler_list.append(_request_handler)

static func _delete_request_handler(_request_handler: RequestHandler, _dict: Dictionary): #called when their request was completed
	for request_handler in request_handler_list:
		if(request_handler == _request_handler):
			instance.remove_child(request_handler)
