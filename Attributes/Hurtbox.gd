extends Area2D

const HIT_EFFECT = preload("res://Effects/Explosion.tscn");

var invincible = false;


func create_hit_effect():
	var effect = HIT_EFFECT.instance();
	var world = get_tree().current_scene;
	world.add_child(effect);
	effect.global_position = global_position;


func _on_InvincibleTimer_timeout() -> void:
	print("Invincible timer started")
	invincible = false;

func set_invincible(value):
	if value == true and invincible == false:
		print("Invincible set to true");
		$InvincibleTimer.start();
	invincible = value;
