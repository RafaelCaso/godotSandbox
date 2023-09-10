extends "res://Ships/Ship.gd"


func _ready() -> void:
	rotation_speed = 500;
	thrust = 1000;
	deceleration_speed = 10000;
	strafe_force = 5000; 
	max_speed = 10000; 
	thrust_energy_consumption = 150; 
