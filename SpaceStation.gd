extends Node2D

onready var sprite = $Sprite;

var rotation_speed : float = 0.1;

func _process(delta) -> void:
	sprite.rotation += rotation_speed * delta

