extends "res://src/Items/ItemPickup.gd"


func _ready() -> void:
	player_state_path = PlayerState.weapons;
	itemID = "laser_0001";
	item_name = "The Purple Nurple";

func _on_Area2D_area_entered(area: Area2D) -> void:
	print(area.get_parent())
	Events.emit_signal("prompt_player", item_name + " added to inventory")
	player_state_path.append(itemID);
	queue_free();
 
