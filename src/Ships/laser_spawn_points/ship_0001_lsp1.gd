extends Node


var laser_spawn_points := [Vector2(0, -80), Vector2(25, -75), Vector2(-25, -75), Vector2(-40, -60), Vector2(40, -60), Vector2(-50, -40), Vector2(50, -40)];


func get_spawn_points() -> Array:
	return laser_spawn_points
