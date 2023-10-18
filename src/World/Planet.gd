extends Node2D

var planet_name = "Earth";

var is_mouse_over = false;
var is_planet_selected = false;

func _on_Area2D_mouse_entered() -> void:
	is_mouse_over = true;
	



func _on_Area2D_mouse_exited() -> void:
	is_mouse_over = false;


func _input(event: InputEvent) -> void:
	if is_mouse_over and event.is_action_pressed("interact"):
		if PlayerState.object_selected:
			is_planet_selected = false;
			PlayerState.object_selected = false;
			$ColorRect.visible = false;
		else:
			Events.emit_signal("prompt_player", planet_name)
			Events.emit_signal("player_effect", "BinaryString");
			is_planet_selected = true;
			PlayerState.object_selected = true;
			$ColorRect.visible = true;


func _on_Area2D_body_entered(body: Node) -> void:
	print(body)
	
	if body.is_in_group("player"):
		print("player entered area2d")
