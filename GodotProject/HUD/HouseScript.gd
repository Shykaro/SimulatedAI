extends Sprite2D

var AssociatedNPC
var NPCManagerRef

func _ready():
	AssociatedNPC = get_parent().get_parent()
	NPCManagerRef = get_parent().get_parent().get_parent()

func _input(event):
	if event.is_action_pressed("click"):
		if is_pixel_opaque(get_local_mouse_position()):
			#print(get_parent().get_parent().emotionalbox.visible)
			if (get_parent().get_parent().emotionalbox.visible):
				get_parent().get_parent().hide_emotionalbox()
				NPCManagerRef.isNPCselected = false
			else:
				if !NPCManagerRef.isNPCselected:
					NPCManagerRef.isNPCselected = true
					get_parent().get_parent().show_emotionalbox()
			print("This is the House of " + AssociatedNPC.name)
