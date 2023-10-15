extends KinematicBody2D

var loot_box_scene = preload("res://src/Items/LootBox.tscn");

onready var sprite = $Sprite;
onready var stats = $Stats;
onready var playerDetectionZone = $PlayerDetectionZone;
onready var hurtBox = $Hurtbox;
onready var wanderController = $WanderController
onready var healthBar = $EnemyHealthBar;

signal enemy_died();

#DON'T THINK I NEED THIS ANYMORE
#DAMAGE BEING HANDLED THROUGH PlayerState.damage_ship(hurt_value)
var player_stats = PlayerStats;

# when true: healthBar UI becomes visible
# not used for handling damage
# currently no logic for flipping BACK TO FALSE
var is_being_hit = false;

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = CHASE;
var can_move : bool = true;
var velocity = Vector2.ZERO;
export var acceleration = 300;
export var max_speed = 50;

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
				velocity = move_and_collide(velocity);
					
			CHASE:
				var player = playerDetectionZone.player
				if player != null:
					var direction = global_position.direction_to(player.global_position);
					velocity = Vector2.move_toward(direction * max_speed, acceleration * delta);
					velocity = move_and_collide(velocity)
				
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
	emit_signal("enemy_died");
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
	player_stats.health -= 1;
	hurtBox.create_hit_effect();
	


func _on_Hitbox_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		PlayerState.damage_ship(10)
		print(body.playerShip.current_health);
