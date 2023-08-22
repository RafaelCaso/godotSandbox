extends KinematicBody2D

onready var LaserScene = preload("res://Weapons/Laser.tscn");
onready var laser = null;
onready var playerSprite = $Sprite;
onready var hurtBox = $Hurtbox;
onready var fusionReactorCore = $FusionReactorCore;

var rotation_speed = 500;
var thrust = 10;
var deceleration_speed = 1000;
var strafe_force = 500;
var velocity = Vector2();
var player_stats = PlayerStats;
var max_speed = 1000;
var laser_energy_consumption = 25;
var energy_recharge_rate = 10;
var thrust_energy_consumption = 15;




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_stats.connect("no_health", self, "queue_free")
	laser = LaserScene.instance();
	add_child(laser);
	laser.position.x = playerSprite.global_position.x;
	laser.position.y = playerSprite.global_position.y - 35;


func main_propulsion(delta, hasSufficientEnergy):
	# Convert the current rotation to a vector2 direction and apply forward thrust
	if hasSufficientEnergy:
		thrust = 10;
	else:
		thrust = 5;
	var direction = Vector2(0, -1).rotated(rotation)
	velocity += direction * thrust
	fusionReactorCore.deplete_energy(thrust_energy_consumption * delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	# Rotation using keyboard
#	if Input.is_action_pressed("ui_left"):
#		rotate_left(delta);
#	elif Input.is_action_pressed("ui_right"):
#		rotate_right(delta);

	var mouse_pos = get_global_mouse_position();
	var direction_to_mouse = (mouse_pos - global_position).normalized();
	rotation = direction_to_mouse.angle() + PI/2;
	
	# Forward Propulsion
	if Input.is_action_pressed("main_propulsion"):
		print(thrust)
		if fusionReactorCore.has_energy(10):
			main_propulsion(delta, true);
		else:
			main_propulsion(delta, false);
	
	# Deceleration
	if Input.is_action_pressed("main_deceleration"):
		velocity = velocity.normalized() * max(0, velocity.length() - deceleration_speed * delta)
		
	
	# Strafe left
	if Input.is_action_pressed("ui_left"):
		var left_direction = Vector2(-1, 0).rotated(rotation)
		velocity += left_direction * strafe_force * delta;
	
	# Strafe right
	if Input.is_action_pressed("ui_right"):
		var right_direction = Vector2(1, 0).rotated(rotation)
		velocity += right_direction * strafe_force * delta;
	
	# Strafe down
	if Input.is_action_pressed("strafe_down"):
		var down_direction = Vector2(0, 1).rotated(rotation);
		velocity += down_direction * strafe_force * delta;
		
	if Input.is_action_pressed("laser") && fusionReactorCore.has_energy(25):
		fusionReactorCore.deplete_energy(laser_energy_consumption * delta);
		print(fusionReactorCore.energy)
		fire_laser();
	else:
		print(fusionReactorCore.energy)
		stop_laser();
	
	fusionReactorCore.set_energy_recharge(energy_recharge_rate * delta)
	
	
func _physics_process(_delta: float) -> void:
	velocity = move_and_slide(velocity).clamped(max_speed);
	

func rotate_left(delta):
	rotation_degrees -= rotation_speed * delta;
	clamp_rotation();

func rotate_right(delta):
	rotation_degrees += rotation_speed * delta;
	clamp_rotation();

func clamp_rotation():
	rotation_degrees = fmod(rotation_degrees, 360)

func fire_laser():
	if not laser.is_casting:
		laser.set_is_casting(true);
	# laser.rotation = rotation;
func stop_laser():
	if laser.is_casting:
		laser.set_is_casting(false);


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	hurtBox.start_invincible(0.5);
	hurtBox.create_hit_effect();
