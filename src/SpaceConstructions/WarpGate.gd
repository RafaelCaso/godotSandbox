extends Control


onready var sprite = $Sprite

export var path : String;

var is_body_entered = false;


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		Events.emit_signal("prompt_player", "Press 'E' To Enter Warp Gate")
		is_body_entered = true;


func _on_Area2D_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		is_body_entered = false;

func _input(event: InputEvent) -> void:
	if is_body_entered and event.is_action_pressed("interact"):
		GameManager.goto_scene(path);
