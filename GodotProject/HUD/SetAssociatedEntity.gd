extends Label

var AssociatedNPC
# Called when the node enters the scene tree for the first time.
func _ready():
	AssociatedNPC = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().AssociatedNPC
	#print(get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent())
	if AssociatedNPC:
		self.text = AssociatedNPC.name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
