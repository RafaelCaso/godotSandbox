extends Node


var laser_spawn_points := [Vector2(0, -30), Vector2(-10, -20), Vector2(10, -20), Vector2(-15, -15), Vector2(15, -15)];


func get_spawn_points() -> Array:
	return laser_spawn_points
