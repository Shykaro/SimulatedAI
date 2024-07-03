extends ScrollContainer

var MemoryActivity #MemoryActivity is Type 1
var MemoryChatting #MemoryChatting is Type 2

# Called when the node enters the scene tree for the first time.
func _ready():
	MemoryActivity = load("res://HUD/Scenes/MemoryActivity.tscn")
	MemoryChatting = load("res://HUD/Scenes/MemoryChatting.tscn")
	#print(get_parent_control().get_parent_control().get_parent().get_parent())

func createMemory(MemoryType: int, MemoryText: String):
	if MemoryType == 1:
		var _memory = MemoryActivity.instantiate()
		get_child(0).add_child(_memory)
		_memory.get_child(0).get_child(0).text = MemoryText
	else: #if not memory type 1 (activity) must be CondensedChat
		var _memory = MemoryChatting.instantiate()
		get_child(0).add_child(_memory)
		_memory.get_child(0).get_child(0).text = MemoryText
	


func updateMessages():
	#self.createMessage()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
