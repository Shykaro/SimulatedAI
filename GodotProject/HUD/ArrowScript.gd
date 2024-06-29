extends Sprite2D

var AssociatedNPC
var conversation_partner

func _ready():
	AssociatedNPC = get_parent()

func _input(event):
	if event.is_action_pressed("click"):
			if is_pixel_opaque(get_local_mouse_position()):
				#print(get_parent().chatbox.visible)
				if (get_parent().chatbox.visible):
					get_parent().hide_chatbox()
				else:
					get_parent().show_chatbox()
				print(AssociatedNPC.name + " is talking with " + AssociatedNPC.conversation_partner.name)
