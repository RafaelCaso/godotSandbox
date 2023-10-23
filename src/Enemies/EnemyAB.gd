extends KinematicBody2D

var loot_box_scene = preload("res://src/Items/LootBox.tscn");

onready var sprite = $Sprite;
onready var stats = $Stats;
onready var playerDetectionZone = $PlayerDetectionZone;
onready var hurtBox = $Hurtbox;
onready var wanderController = $WanderController
#onready var laser_scene = $EnemyLaser
onready var healthBar = $EnemyHealthBar;


# when true: healthBar UI becomes visible
# not used for handling damage
var is_being_hit = false;

enum {
	IDLE,
	WANDER,
	CHASE
}

var laser_scene : LaserBeam = null;

var state = CHASE;
var velocity = Vector2.ZERO;
var can_move : bool = true;
export var stop_distance = 400;
export var acceleration = 300;
export var max_speed = 50;

func _ready() -> void:
	stats.connect("enemy_died", self, "_on_Stats_no_health")
	$Timer.start();
	laser_scene = LaserBeam.new("laser_0003", "enemy")
	add_child(laser_scene);
	laser_scene.global_position = self.global_position;



func _physics_process(delta: float) -> void:
	if is_being_hit:
		healthBar.visible = true;
	healthBar.max_value = stats.max_health;
	healthBar.value = stats.health;
	if can_move:
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
				var collision_info = move_and_collide(velocity);
				
				if collision_info:
					print("EnemyAB.gd Line 47: collision detected")
					state = WANDER;
					
			CHASE:
				var player = playerDetectionZone.player
				if player != null:
					var current_distance = global_position.distance_to(player.global_position);
					var direction = global_position.direction_to(player.global_position);
					var desired_velocity = direction * max_speed;
					if current_distance > stop_distance:
						velocity = Vector2.move_toward(desired_velocity, acceleration * delta);
					# Type error that necessitated below if-check likely resolved. Consider removing 
					if velocity == null:
						print("Velocity is null before interpolation. Current state: ", state);
					else:
						
						velocity = velocity.linear_interpolate(Vector2.ZERO, 0.1);
						
					
	#				velocity = Vector2.move_toward(direction * max_speed, acceleration * delta);
					var collision_info = move_and_collide(velocity)
					
					if collision_info:
						pass;
					
				else:
					state = IDLE;

func _on_Hurtbox_area_entered(_area: Area2D) -> void:
	is_being_hit = true;

func _on_Stats_no_health() -> void:
	var loot_box_instance = loot_box_scene.instance();
	get_parent().add_child(loot_box_instance);
	# not sure why global_position needs to be adjusted, but it does
	# need to find the source for this
	loot_box_instance.global_position = global_position - Vector2(100, 50);
	hurtBox.create_hit_effect();
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
	#****** NEED TO CHANGE TO if area.get_parent().is_in_group("player"): etc
	PlayerStats.health -= 1;
	hurtBox.create_hit_effect();

	


func _on_Timer_timeout() -> void:
	var player = playerDetectionZone.player;
	if player != null:
		var current_distance = global_position.distance_to(player.global_position)
		if playerDetectionZone.can_see_player() and current_distance <= stop_distance:
			shoot_at_player(player);
	else:
		stop_shooting();

func shoot_at_player(player):
	var laser_direction = player.global_position - laser_scene.global_position;
	var angle = atan2(laser_direction.y, laser_direction.x)
	laser_scene.global_rotation = angle + (PI/2)
	laser_scene.is_casting = true;

func stop_shooting():
	laser_scene.is_casting = false;


func _on_Hitbox_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		PlayerState.damage_ship(10, body);
		Events.emit_signal("player_hit");
