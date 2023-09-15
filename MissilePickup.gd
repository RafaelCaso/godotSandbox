extends Node2D





func _on_Area2D_area_entered(_area: Area2D) -> void:
	PlayerState.weapons.append("laser_0001");
	queue_free();
