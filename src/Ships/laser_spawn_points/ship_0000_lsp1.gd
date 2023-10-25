extends Node


var laser_spawn_points := [Vector2(0, -30), Vector2(-10, -15), Vector2(10, -15), Vector2(-15, -20), Vector2(15, -20)];


func get_spawn_points() -> Array:
	return laser_spawn_points
