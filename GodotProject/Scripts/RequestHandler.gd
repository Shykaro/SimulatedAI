extends Node

@onready var line_edit: LineEdit = get_node("CanvasLayer/ColorRect/LineEdit")
var messages = []
var headers = []
var body:String = JSON.stringify({"model": "starling-lm", "messages":[{"role": "user", "content": "Hello, world!"}]})
#{
#     "model": "starling-lm",
#     "messages": [{
#         "role": "user",
#         "content": "Hey Robert, how are you today?"
#     }]
# }
var model: String = "starling-lm"

func _ready():
	line_edit.grab_focus()
	
func _process(delta):
	return
	#var user_input = 
#         if not user_input:
#             exit()
#         print()
#         messages.append({"role": "user", "content": user_input})
#         message = chat(messages)
#         messages.append(message)
#         print("\n\n")
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			print(line_edit.text)
			send(line_edit.text)
			line_edit.clear()
			
	
func send(message):
	$HTTPRequest.request_completed.connect(_on_request_completed)
	#var string_array: PackedStringArray = ["model: model", "messages: {}"]
	$HTTPRequest.request("http://localhost:11434/api/chat", headers, HTTPClient.METHOD_POST, body)

func _on_request_completed(result, response_code, headers, body):
	print("test")
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
	return


# def chat(messages):
#     r = requests.post("http://localhost:11434/api/chat", json={"model": model, "messages": messages, "stream": True})
#     r.raise_for_status()
#     output = ""

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

