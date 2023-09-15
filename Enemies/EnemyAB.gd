extends KinematicBody2D

onready var sprite = $Sprite;
onready var stats = $Stats;
onready var playerDetectionZone = $PlayerDetectionZone;
onready var hurtBox = $Hurtbox;
onready var wanderController = $WanderController

var player_stats = PlayerStats;

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = CHASE;
var velocity = Vector2.ZERO;
export var acceleration = 300;
export var max_speed = 50;



func _physics_process(delta: float) -> void:
	match state:
		IDLE:
			seek_player();
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER]);
				wanderController.start_wander_timer(rand_range(1, 3))
		WANDER:
			seek_player();
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER]);
				wanderController.start_wander_timer(rand_range(1, 10))
				
			var direction = global_position.direction_to(wanderController.target_position);
			velocity = Vector2.move_toward(direction * max_speed, acceleration * delta);
			velocity = move_and_collide(velocity);
				
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var stop_distance = 200;
				var current_distance = global_position.distance_to(player.global_position);
				var direction = global_position.direction_to(player.global_position);
				var desired_velocity = direction * max_speed;
				if current_distance > stop_distance:
					velocity = Vector2.move_toward(desired_velocity, acceleration * delta);
				else:
					velocity = velocity.linear_interpolate(Vector2.ZERO, 0.1);
				
#				velocity = Vector2.move_toward(direction * max_speed, acceleration * delta);
				var collision_info = move_and_collide(velocity)
				
				if collision_info:
					pass;
			
			else:
				state = IDLE;

func _on_Hurtbox_area_entered(_area: Area2D) -> void:
	stats.health -= 1;
	
	



func _on_Stats_no_health() -> void:
	var Explosion = load("res://Effects/Explosion.tscn");
	var explosion = Explosion.instance();
	var world = get_tree().current_scene;
	world.add_child(explosion);
	explosion.global_position = global_position;
	
	queue_free();

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE;

# shuffles list of states and picks the first one
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func apply_knockback_from(position: Vector2, force: float) -> void:
	var knockback_direction = global_position - position;
	velocity += knockback_direction.normalized() * force;


func _on_Hitbox_area_entered(_area: Area2D) -> void:
	player_stats.health -= 1;
	hurtBox.create_hit_effect();
	
