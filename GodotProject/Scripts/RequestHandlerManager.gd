extends Node

class_name RequestHandlerManager
#Manages the creation, communication and deletion of request handlers
static var instance: RequestHandlerManager 
static var request_handler_list: Array = []

func _ready():
	instance = self

static func request_check_conversation_over(_npc: NPC, _message: String):
	var associated_llm = _npc.associated_llm
	var _request_handler: RequestHandler = RequestHandler.new()
	instance.add_child(_request_handler)
	_request_handler.request_processed.connect(_npc.mind._on_request_conversation_over_completed)
	_request_handler.request_processed.connect(instance._delete_request_handler)
	_request_handler.generate(_message, associated_llm)
	request_handler_list.append(_request_handler)

static func request_emotional_state_update(_npc: NPC, _message: String):
	var associated_llm = _npc.associated_llm
	var _request_handler: RequestHandler = RequestHandler.new()
	instance.add_child(_request_handler)
	_request_handler.request_processed.connect(_npc.mind._on_request_emotional_state_complete)
	_request_handler.request_processed.connect(instance._delete_request_handler)
	_request_handler.generate(_message, associated_llm)
	request_handler_list.append(_request_handler)

static func request_update_relation(_npc: NPC, _message: String):
	var associated_llm = _npc.associated_llm
	var _request_handler: RequestHandler = RequestHandler.new()
	instance.add_child(_request_handler)
	_request_handler.request_processed.connect(_npc.mind._on_request_update_relation_completed)
	_request_handler.request_processed.connect(instance._delete_request_handler)
	_request_handler.generate(_message, associated_llm)
	request_handler_list.append(_request_handler)

#seperate decide emotional relation request (Requests could be bundled to one "request answer"?? -> Different requests are easier to visualize)
static func request_decide_relation(_npc: NPC, _message: String):
	var associated_llm = _npc.associated_llm
	var _request_handler: RequestHandler = RequestHandler.new()
	instance.add_child(_request_handler)
	_request_handler.request_processed.connect(_npc.mind._on_request_decide_relation_completed)
	_request_handler.request_processed.connect(instance._delete_request_handler)
	_request_handler.generate(_message, associated_llm)
	request_handler_list.append(_request_handler)

static func request_condense_activity(_npc: NPC, _message: String):
	var associated_llm = _npc.associated_llm
	var _request_handler: RequestHandler = RequestHandler.new()
	instance.add_child(_request_handler)
	_request_handler.request_processed.connect(_npc.mind._on_request_condense_activity_completed)
	_request_handler.request_processed.connect(instance._delete_request_handler)
	_request_handler.generate(_message, associated_llm)
	request_handler_list.append(_request_handler)

static func request_chat_api(_npc: NPC, _messages: Array): #chat api uses context and is passed an array
	var associated_llm = _npc.associated_llm
	var _request_handler: RequestHandler = RequestHandler.new()
	instance.add_child(_request_handler)
	_request_handler.request_processed.connect(_npc._on_request_completed)
	_request_handler.request_processed.connect(instance._delete_request_handler)
	_request_handler.chat(_messages, associated_llm)
	request_handler_list.append(_request_handler)

static func request_generate_api(_npc: NPC, _message: String): #generate api doesnt use context
	var associated_llm = _npc.associated_llm
	var _request_handler: RequestHandler = RequestHandler.new()
	instance.add_child(_request_handler)
	_request_handler.request_processed.connect(_npc._on_request_completed)
	_request_handler.request_processed.connect(instance._delete_request_handler)
	_request_handler.generate(_message, associated_llm)
	request_handler_list.append(_request_handler)



static func _delete_request_handler(_request_handler: RequestHandler, _dict: Dictionary): #called when their request was completed
	for request_handler in request_handler_list:
		if(request_handler == _request_handler):
			instance.remove_child(request_handler)
