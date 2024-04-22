extends HTTPRequest

var model = "starling-lm"
var headers = []#["Content-Type: application/json"]
#var body:String = JSON.stringify({"model": model, "messages": messages})
var prompt:String = "Hello, world!"
var body:String = JSON.stringify({"model": model, "prompt": prompt, "stream": false})

func _ready():
	send("test")
	
func send(message):
	self.request_completed.connect(_on_request_completed)
	var prompt = message
	self.request("http://localhost:11434/api/generate", headers, HTTPClient.METHOD_POST, body) #JSON.parse_string(body)
	print("message sent!")

func _on_request_completed(result, response_code, headers, body):
	print("request completed!")
	#print(body)
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
	return
