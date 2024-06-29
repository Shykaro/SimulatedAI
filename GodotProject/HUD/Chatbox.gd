extends Node

var AssociatedNPC
var conversation_partner = " " #this is conversation_partner.name from NPC!! updates every conversation initiate

# Called when the node enters the scene tree for the first time.
func _ready():
	AssociatedNPC = get_parent().get_parent()
	get_child(0).get_child(0).text = AssociatedNPC.name + " and " + conversation_partner

func updateChat(NewPartner):
	conversation_partner = NewPartner
	get_child(0).get_child(0).text = AssociatedNPC.name + " and " + conversation_partner

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
