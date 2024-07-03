extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var show_time: int = GameManager.hour
	if(show_time==1): show_time = 2
	self.text = str(show_time-1)+GameManager.time_of_day
	
