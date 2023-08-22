extends Node2D

onready var animatedSprite = $Explosion;

func _ready() -> void:
	animatedSprite.frame = 0;
	animatedSprite.play("explosion")



func _on_Explosion_animation_finished() -> void:
	animatedSprite.queue_free();
