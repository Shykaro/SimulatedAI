extends Sprite2D

var AssociatedNPC
var NPCManagerRef

func _ready():
	AssociatedNPC = get_parent().get_parent()
	NPCManagerRef = get_parent().get_parent().get_parent()
	var material = load("res://Scenes/houses.gdshader")
	#var Shade: ShaderMaterial = material.get_active_material(0)
	

func _input(event):
	if event.is_action_pressed("click"):
		if is_pixel_opaque(get_local_mouse_position()):
			#print(get_parent().get_parent().emotionalbox.visible)
			if (get_parent().get_parent().emotionalbox.visible):
				get_parent().get_parent().hide_emotionalbox()
				NPCManagerRef.isNPCselected = false
				material.set_shader_parameter("line_color", Vector4(0, 1, 0, 0))
			else:
				if !NPCManagerRef.isNPCselected:
					NPCManagerRef.isNPCselected = true
					material.set_shader_parameter("line_color", Vector4(0, 1, 0, 1))
					get_parent().get_parent().show_emotionalbox()
			#print("This is the House of " + AssociatedNPC.name)
