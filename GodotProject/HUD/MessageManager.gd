extends ScrollContainer
var MessageBoxOG #MessageBox Prefab for the current chosen NPC
var MessageBoxCP #MessageBox Prefab for the current conversation partner of chosen NPC

# Called when the node enters the scene tree for the first time.
func _ready():
	MessageBoxOG = load("res://HUD/Scenes/MessageBoxOG.tscn")
	MessageBoxCP = load("res://HUD/Scenes/MessageBoxCP.tscn")
	#print(get_parent_control().get_parent_control().get_parent().get_parent())

func createMessage(_npc: NPC, MessageText: String):
	if _npc == get_parent_control().get_parent_control().get_parent().get_parent(): #checks with NPC node, if sent NPC is self
		var _message = MessageBoxOG.instantiate()
		get_child(0).add_child(_message)
		_message.get_child(0).get_child(0).text = MessageText
	else: #if not, must be conversationpartner
		var _message = MessageBoxCP.instantiate()
		get_child(0).add_child(_message)
		_message.get_child(0).get_child(0).text = MessageText
	


func updateMessages():
	#self.createMessage()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
