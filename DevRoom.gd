extends Node2D

func _ready() -> void:
	var laser = LaserBeam.new("laser_0004");
	laser.global_position = Vector2(365, 478)
	add_child(laser)
