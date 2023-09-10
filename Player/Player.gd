extends KinematicBody2D

signal energy_changed(new_energy);
signal change_scene(new_scene_path);

onready var LaserScene = preload("res://Weapons/TestLaser.tscn");
onready var baseShip = $Ship;
onready var laser = null;
onready var playerShip = null;
onready var playerSprite = $Sprite;
onready var hurtBox = $Hurtbox;
onready var fusionReactorCore = $FusionReactorCore;
onready var laserSpawnPoint = $LaserSpawnPoint;

var velocity = Vector2();
var energy_recharge_rate = 10;
var weapons = [];
var available_ships = [];

func _ready() -> void:
	PlayerStats.connect("no_health", self, "queue_free")
	fusionReactorCore.connect("energy_changed", Hud, "_on_Player_energy_changed")
	laser = LaserScene.instance();
	playerShip = baseShip;
	playerShip.configure_ship("ship_0000");
	playerSprite.texture = playerShip.sprite.texture;
	playerSprite.global_position = global_position;
	add_child(laser);
	laser.global_position.x = laserSpawnPoint.global_position.x;
	laser.global_position.y = laserSpawnPoint.global_position.y;
	


func main_propulsion(delta, hasSufficientEnergy):
	# Convert the current rotation to a vector2 direction and apply forward thrust
	var thrust;
	if hasSufficientEnergy:
		thrust = playerShip.thrust;
	else:
		thrust = playerShip.thrust / 5;
	var direction = Vector2(0, -1).rotated(rotation)
	velocity += direction * thrust
	fusionReactorCore.deplete_energy(playerShip.thrust_energy_consumption * delta)
	


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

	if Input.is_action_just_pressed("weapon1"):
		equip_weapon("res://Weapons/TestLaser.tscn");
	if Input.is_action_just_pressed("weapon2"):
		equip_weapon("res://Weapons/Laser.tscn");
		
		
	# Forward Propulsion
	if Input.is_action_pressed("main_propulsion"):
		if fusionReactorCore.has_energy(10):
			main_propulsion(delta, true);
		else:
			main_propulsion(delta, false);
	
	# Deceleration
	if Input.is_action_pressed("main_deceleration"):
		velocity = velocity.normalized() * max(0, velocity.length() - playerShip.deceleration_speed * delta)
		
	
	# Strafe left
	if Input.is_action_pressed("ui_left"):
		var left_direction = Vector2(-1, 0).rotated(rotation)
		velocity += left_direction * playerShip.strafe_force * delta;
	
	# Strafe right
	if Input.is_action_pressed("ui_right"):
		var right_direction = Vector2(1, 0).rotated(rotation)
		velocity += right_direction * playerShip.strafe_force * delta;
	
	# Strafe down
	if Input.is_action_pressed("strafe_down"):
		var down_direction = Vector2(0, 1).rotated(rotation);
		velocity += down_direction * playerShip.strafe_force * delta;
		
	if Input.is_action_pressed("laser") && fusionReactorCore.has_energy(25):
		fusionReactorCore.deplete_energy(laser.laser_energy_consumption * delta);
#		emit_signal("energy_changed", fusionReactorCore.energy)
		fire_laser();
	else:
		stop_laser();
	
	if Input.is_action_just_pressed("change_ship_test"):
		change_ship("ship_0001");
	
	if Input.is_action_just_pressed("test_button"):
		emit_signal("change_scene", "res://World2.tscn");
	
	fusionReactorCore.set_energy_recharge(energy_recharge_rate * delta)
		
func _physics_process(_delta: float) -> void:
	velocity = move_and_slide(velocity).clamped(playerShip.max_speed);
	
# ********ONLY NEEDED FOR ALTERNATE CONTROL STYLE ***********
# ********NEED TESTING RE: WHICH IS BETTER? KEYBOARD ROTATE VS FOLLOW MOUSE *********
#func rotate_left(delta):
#	rotation_degrees -= playerShip.rotation_speed * delta;
#	clamp_rotation();
#
#func rotate_right(delta):
#	rotation_degrees += playerShip.rotation_speed * delta;
#	clamp_rotation();

func clamp_rotation():
	rotation_degrees = fmod(rotation_degrees, 360)

func fire_laser():
	if not laser.is_casting:
		laser.set_is_casting(true);
	
func stop_laser():
	if laser.is_casting:
		laser.set_is_casting(false);

#*********** NOT FUNCTIONING CORRECTLY/AT ALL *********
func _on_Hurtbox_area_entered(_area: Area2D) -> void:
	hurtBox.start_invincible(0.5);
	hurtBox.create_hit_effect();

func add_weapon(weapon):
	weapons.append(weapon);

func equip_weapon(weapon):
	remove_child(laser);
	var LaserToEquip = load(weapon);
	var laser_to_equip = LaserToEquip.instance();
	add_child(laser_to_equip);
	laser = laser_to_equip;
	laser_to_equip.global_position.x = laserSpawnPoint.global_position.x;
	laser_to_equip.global_position.y = laserSpawnPoint.global_position.y;

func change_ship(ship_id : String):
	playerShip.configure_ship(ship_id);
	playerSprite.texture = playerShip.sprite.texture;
