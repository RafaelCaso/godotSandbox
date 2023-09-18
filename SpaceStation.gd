extends Node2D

onready var sprite = $Sprite;

var rotation_speed : float = 0.1;
var player = null;

func _process(delta) -> void:
	sprite.rotation += rotation_speed * delta

func repair_ship():
	PlayerStats.heal(1);

func _on_Timer_timeout() -> void:
	repair_ship();
	print("timer timeout!")


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		$Area2D/Timer.start();
