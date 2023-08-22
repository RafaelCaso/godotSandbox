extends Camera2D


var zoom_speed = 0.1;
var max_zoom = Vector2(5,5);
var min_zoom = Vector2(0.5, 0.5);

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		var zoom_change = Vector2(0,0);
		if Input.is_action_just_pressed("zoom_in"):
			
			zoom_change = Vector2(-zoom_speed, -zoom_speed);
		
		if Input.is_action_just_pressed("zoom_out"):
			zoom_change = Vector2(zoom_speed, zoom_speed)
		
		zoom += zoom_change;
		zoom.x = clamp(zoom.x, min_zoom.x, max_zoom.x)
		zoom.y = clamp(zoom.y, min_zoom.y, max_zoom.y)
