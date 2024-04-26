extends HTTPRequest

var model = "phi" #"starling-lm"
var headers = [] #["Content-Type: application/json"]
var prompt: String = "Hello, world!"
var messages: Array = []
#var body: String = JSON.stringify({"model": model, "prompt": prompt, "stream": false})
signal request_processed(dict: Dictionary)

#for chatting:
#var messages = [{"role": "user", "content": "Hello, world!"}]
#var body:String = JSON.stringify({"model": model, "messages": messages})

func _get_body():
	var body: String = JSON.stringify({"model": model, "prompt": prompt, "stream": false})
	return body

func send(new_text):
	#self.request_completed.connect(_on_request_completed)
	prompt = new_text
	self.request("http://localhost:11434/api/generate", headers, HTTPClient.METHOD_POST, _get_body())
	#print(body)

func _on_request_completed(result: int, response_code: int, headers, body):
	print("request completed with response code "+str(response_code)+" and result "+str(result))
	var json: Dictionary = JSON.parse_string(body.get_string_from_utf8())	
	if(json!=null):
		messages.append(json["message"])
		print(messages)
		request_processed.emit(json)
	else:
		print("JSON was empty!")

func chat(message: String):
	messages.append({"role": "user", "content": message})
	self.request("http://localhost:11434/api/chat", [], HTTPClient.METHOD_POST, JSON.stringify({"model": model, "messages": messages, "stream": false}))



#     for line in r.iter_lines():
#         body = json.loads(line)
#         if "error" in body:
#             raise Exception(body["error"])
#         if body.get("done") is False:
#             message = body.get("message", "")
#             content = message.get("content", "")
#             output += content
#             # the response steams one token at a time, print that as we receive it
#             print(content, end="", flush=True)
#         if body.get("done", False):
#             message["content"] = output
#             return message


# def main():
#     messages = []
#     while True:
#         user_input = input("Enter a message: ")
#         if not user_input:
#             exit()
#         print()
#         messages.append({"role": "user", "content": user_input})
#         message = chat(messages)
#         messages.append(message)
#         print("\n\n")

# if __name__ == "__main__":
#     main()

