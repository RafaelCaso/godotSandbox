extends Node


var laser_spawn_points := [Vector2(0, -120), Vector2(-27, -90), Vector2(27, -90), Vector2(-41, -30), Vector2(41, -30), Vector2(-46, -22), Vector2(46, -22), Vector2(-51, -15), Vector2(51, -15), Vector2(-64, 7), Vector2(64, 7)];


func get_spawn_points() -> Array:
	return laser_spawn_points
