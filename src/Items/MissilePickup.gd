extends "res://src/Items/ItemPickup.gd"


func _ready() -> void:
	player_state_path = PlayerState.weapons;
	itemID = "laser_0001"


func _on_Area2D_area_entered(_area: Area2D) -> void:
	player_state_path.append(itemID);
	queue_free();
