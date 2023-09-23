extends "res://Ships/Ship.gd"


func _ready() -> void:
	rotation_speed = 500;
	thrust = 10;
	deceleration_speed = 1000;
	strafe_force = 500; 
	max_speed = 1000; 
	thrust_energy_consumption = 15; 

