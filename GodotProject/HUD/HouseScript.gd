extends Sprite2D

var AssociatedNPC

func _ready():
	AssociatedNPC = get_parent().get_parent()

func _input(event):
	if event.is_action_pressed("click"):
			if is_pixel_opaque(get_local_mouse_position()):
				
				print("This is the House of " + AssociatedNPC.name)
