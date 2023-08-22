extends Area2D

const HIT_EFFECT = preload("res://Effects/Explosion.tscn");

onready var timer = $Timer;

var invincible = false setget set_invincible;

signal invincible_started;
signal invincible_ended;

func set_invincible(value):
	invincible = value;
	if invincible == true:
		emit_signal("invincible_started");
	else:
		emit_signal("invincible_ended");

func start_invincible(duration):
	self.invincible = true;
	timer.start(duration);

func create_hit_effect():
	var effect = HIT_EFFECT.instance();
	var world = get_tree().current_scene;
	world.add_child(effect);
	effect.global_position = global_position;
	


func _on_Timer_timeout() -> void:
	self.invincible = false;


func _on_Hurtbox_invincible_ended() -> void:
	print("ended")
	monitorable = true;


func _on_Hurtbox_invincible_started() -> void:
	print("started")
	set_deferred("monitorable", false);
