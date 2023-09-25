extends KinematicBody2D

onready var lifeSpan = $LifeSpan;

var speed = 20000  
var direction = Vector2.ZERO

var missile_scene = preload("res://src/Weapons/UnguidedMissile.tscn")

var is_detonated = false;

func _ready() -> void:
	lifeSpan.start();

# This function sets the direction of the missile based on the target.
func set_direction(target_pos):
	direction = (target_pos - global_position).normalized()

func _physics_process(delta):
	if is_detonated:
		queue_free();
		return;
	var _missile_move_and_slide = move_and_slide(direction * speed * delta);
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("missile"):
		detonate();

func detonate():
	is_detonated = true;
	
	var angles = [0, 45, 90, 135, 180, 225, 270, 315];
	
	for angle in angles:
		var new_direction = Vector2.RIGHT.rotated(deg2rad(angle));
		var new_missile = missile_scene.instance();
		get_parent().add_child(new_missile);
		new_missile.global_position = global_position;
		new_missile.set_direction(global_position + new_direction)


func _on_HitBox_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		body.queue_free()
	queue_free();


func _on_LifeSpan_timeout() -> void:
	detonate();
