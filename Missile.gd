extends KinematicBody2D

onready var lifeSpan = $LifeSpan;

var speed = 20000  
var direction = Vector2()

# This function sets the direction of the missile based on the target.
func set_direction(target_pos):
	direction = (target_pos - global_position).normalized()

func _physics_process(delta):
	var _missileMoveAndSlide = move_and_slide(direction * speed * delta);
	
	


func _on_HitBox_body_entered(body: Node) -> void:
	queue_free();
	body.queue_free();


func _on_LifeSpan_timeout() -> void:
	var Explosion = load("res://Effects/Explosion.tscn");
	var explosion = Explosion.instance();
	var world = get_tree().current_scene;
	world.add_child(explosion);
	explosion.global_position = global_position;
	queue_free();
