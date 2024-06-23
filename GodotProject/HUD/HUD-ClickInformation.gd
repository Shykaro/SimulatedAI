extends Node

@onready var clickable_information_panel = $ClickableInformationPanel
@onready var chat_panel = $ClickableInformationPanel/ChatPanel
@onready var memory_panel = $ClickableInformationPanel/MemoryPanel

# Called when the node enters the scene tree for the first time.
# REPLACE WITH ON CLICK ARROW
func _ready():
	clickable_information_panel.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# WHEN CLICKED ON ANOTHER ARROW, CLOSE, AND OPEN NEW WINDOW
#func ????():
#	clickable_information_panel.hide()

#func _input(event):
#	if event.is_action_pressed():
#		if IsMouseOverArrow():
#			print("You clicked on an Arrow!")
			
#func IsMouseOverArrow():
#	var arrow = get_arrow()
#	arrow.position += position
#	if arrow.has_point(get_global_mouse_position()):
#		return true
#	return false
