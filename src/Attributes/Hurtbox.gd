extends Area2D

const HIT_EFFECT = preload("res://src/Effects/Explosion.tscn");

var invincible = false;


func create_hit_effect():
	var effect = HIT_EFFECT.instance();
	var world = get_tree().current_scene;
	world.add_child(effect);
	effect.global_position = global_position;


# Give Player a short invincibility buff after receiving damage
# Simple boolean flag which is checked in the attacking entity's script
# If invincible == true, no damage is dealt
func set_invincible(value):
	if value == true and invincible == false:
		$InvincibleTimer.start();
	invincible = value;

func _on_InvincibleTimer_timeout() -> void:
	invincible = false;


