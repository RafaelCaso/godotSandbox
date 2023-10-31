class_name Shield
extends Node2D

onready var animatedSprite = $AnimatedSprite;

signal shield_hit;

var shields_active : bool = false;
var required_frc_energy : int = 75;
var fighter_shield_cs = preload("res://src/Shields/collision_shapes/shield_0000_collision_shape.tscn")
var fighter_shield_sprite = preload("res://src/Shields/animated_sprites/shield_0000_animated_sprite.tscn")
var shields_offline : bool = false;

var area2D : Area2D;
var sprite : AnimatedSprite

func _init() -> void:
	area2D = fighter_shield_cs.instance()
	var _a2d = area2D.connect("area_entered", self, "_on_Area2D_area_entered")
	
	sprite = fighter_shield_sprite.instance()
	var _ssc = sprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	
	add_child(area2D)	
	add_child(sprite);
	
func _ready() -> void:
	area2D.collision_layer = 8;
	area2D.collision_layer = 2;
	area2D.collision_mask = 6;
	sprite.visible = false;
	shields_down();


func shield_hit() -> void:
	if ! shields_offline:
		emit_signal("shield_hit");
		sprite.visible = true;
		play_animation();

#*******NOT WORKING*************
func shield_offline():
	shields_down();
	shields_offline = true;
	Events.emit_signal("shields_offline")
	Events.emit_signal("warn_player", "Shields are offline! One minute to reboot")
	shields_active = false;
	area2D.set_deferred("monitorable", false);
	area2D.get_child(0).set_deferred("monitorable", false);
	var offline_timer = Timer.new()
	offline_timer.one_shot = true;
	offline_timer.connect("timeout", self, "on_offline_timeout");
	add_child(offline_timer)
	offline_timer.start(60)

func on_offline_timeout():
	shields_offline = false;
	Events.emit_signal("shields_back_online")
	area2D.set_deferred("monitorable", true);
	area2D.get_child(0).set_deferred("monitorable", true);
	Events.emit_signal("prompt_player", "Shields are back online")

func _on_AnimatedSprite_animation_finished() -> void:
	sprite.visible = false;


func _on_Area2D_area_entered(_area: Area2D) -> void:
	if ! shields_offline:
		shield_hit();

func shields_up():
	if ! shields_offline:
		play_animation();
		shields_active = true;
		Events.emit_signal("shields_toggled", shields_active);
		area2D.set_deferred("monitorable", true);
		area2D.get_child(0).set_deferred("disabled", false);

func shields_down():
	if ! shields_offline:
		shields_active = false;
		Events.emit_signal("shields_toggled", shields_active);
		area2D.set_deferred("monitorable", false);
		area2D.get_child(0).set_deferred("disabled", true);

func play_animation():
	sprite.frame = 0;
	sprite.visible = true;
	sprite.play("shield_hit_alternate");
