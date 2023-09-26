extends "res://src/Ships/Ship.gd"


var locations_visited = [];

func _ready() -> void:
	area2D.connect("body_entered", self, "_on_body_entered");
	

func _on_body_entered(body):
	if body.is_in_group("locations"):
		locations_visited.append(body.locationID);

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("change_ship_test"):
		print("Script dynamically loaded");
