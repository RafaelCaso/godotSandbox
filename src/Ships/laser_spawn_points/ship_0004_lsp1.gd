extends Node

var laser_spawn_points := [Vector2(0, -80), Vector2(-20, -75), Vector2(20, -75), Vector2(-35, -65), Vector2(35, -65), Vector2(-40, -55), Vector2(40, -55), Vector2(-50, -45), Vector2(50, -45), Vector2(-65, -45), Vector2(65, -45)];


func get_spawn_points() -> Array:
	return laser_spawn_points

