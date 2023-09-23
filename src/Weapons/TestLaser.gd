extends "res://Weapons/Laser.gd"

func _ready() -> void:
	max_length = 400;
	set_laser_color("#b603fc")
	path = "res://Weapons/TestLaser.tscn"
