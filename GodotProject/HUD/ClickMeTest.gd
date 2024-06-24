extends Area2D

func _input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		print("You clicked me! Hehe")

var epsilon : int = 1
var polys  = []
var collision_polygon

func _ready():
	SpriteToPolygon()

func SpriteToPolygon():
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(get_parent().get_texture().get_image())
	
	polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, get_parent().get_texture().get_size()), epsilon)
	
	for poly in polys:
		
		collision_polygon = CollisionPolygon2D.new()
		collision_polygon.polygon = poly
		add_child(collision_polygon)
		
		if get_parent().centered:
			collision_polygon.position += Vector2(bitmap.get_size() / 2)
			collision_polygon.position += get_parent().offset

func _draw():
	for i in range(1, len(collision_polygon.polygon)):
		draw_line(collision_polygon.polygon[i] + collision_polygon.position, collision_polygon.polygon[i-1] + collision_polygon.position, Color.RED, 0.5, true)
