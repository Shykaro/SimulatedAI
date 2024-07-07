extends Label

var ConversationPartner
# Called when the node enters the scene tree for the first time.
func _ready():
	ConversationPartner = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().conversation_partner
	#print(get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent())
	if ConversationPartner:
		self.text = ConversationPartner

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
