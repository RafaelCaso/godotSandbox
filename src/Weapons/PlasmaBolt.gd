extends KinematicBody2D

onready var particles = $Particles2D;

var velocity;
var target;
var direction;
var speed = 2000;

var distance_traveled := 0.0;
var max_distance := 1000.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

func _physics_process(delta: float) -> void:
	shoot_in_direction(delta);
	distance_traveled += velocity.length() * delta;
	if distance_traveled >= max_distance:
		queue_free()

func shoot_in_direction(delta):
	velocity = direction * speed;
	var collide = move_and_collide(velocity * delta);
	if collide:
		queue_free();
		
func calculate_direction():
	target = get_global_mouse_position();
	direction = (target - global_position).normalized();
	var angle = direction.angle() + PI;
	particles.rotation = angle;
