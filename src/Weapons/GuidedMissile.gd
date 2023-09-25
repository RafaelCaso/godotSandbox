extends "res://src/Weapons/BaseMissile.gd"


var max_speed := 1000.0;
var drag_factor := 0.15 setget set_drag_factor;

var _target;

var _current_velocity := Vector2.ZERO;

onready var _sprite := $Sprite;
onready var _hitbox := $HitBox;
onready var _enemy_detector := $EnemyDetector;
onready var life_span = $LifeSpan;

func _ready() -> void:
	life_span.start();
	# ****** Vector2.RIGHT might need to be changed
	_current_velocity = max_speed * Vector2.RIGHT.rotated(rotation);

func _physics_process(delta: float) -> void:
	#******* Vector2.RIGHT might need to be changed
#	var direction := Vector2.RIGHT.rotated(rotation).normalized();
	var direction := _current_velocity.normalized()
	
	if _target and is_instance_valid(_target):
		direction = global_position.direction_to(_target.global_position).normalized();
	
	var desired_velocity := direction * max_speed;
#	var previous_velocity = _current_velocity;
	var change = (desired_velocity - _current_velocity) * drag_factor;
	
	_current_velocity += change;
	
	position += _current_velocity * delta;
	look_at(global_position + _current_velocity);

func set_drag_factor(setter):
	drag_factor = clamp(setter, 0.01, 0.5);


func _on_EnemyDetector_body_entered(body: Node) -> void:
	search_for_target(body);

func search_for_target(body):
	if body.is_in_group("enemies"):
		_target = body;

func set_direction(target_pos):
	_current_velocity = (target_pos - global_position).normalized()


func _on_HitBox_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		body.queue_free();
		queue_free();
	elif body.is_in_group("player"):
		pass;



func _on_LifeSpan_timeout() -> void:
	queue_free();
