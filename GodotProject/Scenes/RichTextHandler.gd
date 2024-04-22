extends RichTextLabel

var count: int
var is_waiting: bool = false

func update_llm_text(json: Dictionary):
	self.newline()
	self.append_text("LLM > "+str(json["response"]))
	self.newline()
	print(json)
	is_waiting = false

func update_user_text(new_text: String):
	self.append_text("You > "+new_text)
	self.newline()
	#self.text. += "You > "+new_text
	is_waiting = true
	
func _process(delta):
	count += 1
	if is_waiting:
		if(count%100==0):
			self.append_text(".")
	
