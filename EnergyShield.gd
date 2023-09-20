extends Node2D

onready var animatedSprite = $AnimatedSprite;

signal shield_hit;
signal shields_toggled(shields_active)

var shields_active : bool = false;
var required_frc_energy : int = 75;

func _ready() -> void:
	shields_down();
	animatedSprite.visible = false;


func shield_hit() -> void:
	emit_signal("shield_hit");
	animatedSprite.frame = 0;
	animatedSprite.visible = true;
	play_animation();

#*******NOT WORKING*************
func shield_offline():
	shields_active = false;
	$Area2D.set_deferred("monitorable", false);
	$Area2D/CollisionShape2D.set_deferred("monitorable", false);

func _on_AnimatedSprite_animation_finished() -> void:
	animatedSprite.visible = false;


func _on_Area2D_area_entered(_area: Area2D) -> void:
	shield_hit();

func shields_up():
	play_animation();
	shields_active = true;
	emit_signal("shields_toggled", shields_active);
	$Area2D.monitorable = true;
	$Area2D/CollisionShape2D.disabled = false;

func shields_down():
	shields_active = false;
	emit_signal("shields_toggled", shields_active);
	$Area2D.monitorable = false;
	$Area2D/CollisionShape2D.disabled = true;

func play_animation():
	animatedSprite.visible = true;
	animatedSprite.play("shield_hit_alternate");
