extends Sprite2D

var AssociatedNPC
var conversation_partner
var NPCManagerRef

func _ready():
	AssociatedNPC = get_parent()
	NPCManagerRef = get_parent().get_parent()
	print(get_parent().get_parent())

func _input(event):
	if event.is_action_pressed("click"):
			if is_pixel_opaque(get_local_mouse_position()):
				#print(get_parent().chatbox.visible)
				if (get_parent().chatbox.visible):
					get_parent().hide_chatbox()
					NPCManagerRef.isConversationSelected = false
				else:
					if NPCManagerRef.isConversationSelected == false:
						NPCManagerRef.isConversationSelected = true
						get_parent().show_chatbox()
				print(AssociatedNPC.name + " is talking with " + AssociatedNPC.conversation_partner.name)
