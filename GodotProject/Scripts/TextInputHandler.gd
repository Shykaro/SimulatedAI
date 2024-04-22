extends LineEdit
#also provides text_submitted signal to call on_text_submitted in RequestHandler

func _ready():
	self.grab_focus()
