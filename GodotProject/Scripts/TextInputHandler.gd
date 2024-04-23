extends LineEdit
#also provides text_submitted signal to call on_text_submitted in RequestHandler

func _ready():
	self.grab_focus()


func _on_text_submitted(new_text):
	OS.delay_msec(200)
	self.clear()
