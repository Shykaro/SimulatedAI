extends HTTPRequest

class_name RequestHandler

var model = "phi" #"starling-lm"
var headers = [] #["Content-Type: application/json"]
var prompt: String = "Hello, world!"
var messages: Array = []
#var body: String = JSON.stringify({"model": model, "prompt": prompt, "stream": false})
signal request_processed(dict: Dictionary)

#for chatting:
#var messages = [{"role": "user", "content": "Hello, world!"}]
#var body:String = JSON.stringify({"model": model, "messages": messages})
func _ready():
	self.request_completed.connect(_on_request_completed)
	pass

func _on_request_completed(result: int, response_code: int, headers, body):
	print("request completed with response code "+str(response_code)+" and result "+str(result))
	print(body)
	var json_string = body.get_string_from_utf8()
	print(json_string)
	var json: Dictionary = JSON.parse_string(json_string)
	if(json!=null):
		#print(json)
		messages.append(json["message"])
		#print(messages)
		request_processed.emit(json)
	else:
		print("JSON was empty!")

func chat(message: String, _model = null):
	#print("Chat sent!")
	if(_model==null): _model = model 
	messages.append({"role": "user", "content": message})
	self.request("http://localhost:11434/api/chat", [], HTTPClient.METHOD_POST, JSON.stringify({"model": _model, "messages": messages, "stream": false})) #"options": {"num_predict": 30}}))
#num_predict: max number of tokens: 30 is equivalent to 1-2 sentences
