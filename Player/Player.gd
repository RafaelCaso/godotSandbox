extends KinematicBody2D

signal change_scene(new_scene_path);

#onready var LaserScene = preload("res://Weapons/TestLaser.tscn");
onready var baseShip = $Ship;
onready var baseLaser = $Weapons/Lasers;
onready var equippedLaser = null;
onready var playerShip = null;
onready var playerSprite = $Sprite;
onready var hurtBox = $Hurtbox;
onready var fusionReactorCore = $FusionReactorCore;
onready var laserSpawnPoint = $LaserSpawnPoint;

var velocity = Vector2();

func _ready() -> void:
	PlayerStats.connect("no_health", self, "queue_free")
	fusionReactorCore.connect("energy_changed", Hud, "_on_Player_energy_changed")
#	laser = LaserScene.instance();
	playerShip = baseShip;
	
	playerShip.configure_ship(PlayerState.shipID);
	
	playerSprite.texture = playerShip.sprite.texture;
	playerSprite.global_position = global_position;
#	add_child(laser);
	equippedLaser = baseLaser;
	equippedLaser.configure_laser(PlayerState.equippedLaserID);
	equippedLaser.global_position = laserSpawnPoint.global_position;

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position();
	var direction_to_mouse = (mouse_pos - global_position)
	equippedLaser.cast_to = equippedLaser.to_local(global_position + direction_to_mouse * equippedLaser.max_length);
	equippedLaser.global_position = laserSpawnPoint.global_position;
	rotation = direction_to_mouse.angle() + PI/2;

	if Input.is_action_just_pressed("weapon1"):
		equip_weapon("laser_0000");
	if Input.is_action_just_pressed("weapon2"):
		equip_weapon("laser_0001");
		
	if Input.is_action_pressed("laser") && fusionReactorCore.has_energy(25):
		fusionReactorCore.deplete_energy(equippedLaser.laser_energy_consumption * delta);
		fire_laser();
	else:
		stop_laser();
	
	if Input.is_action_just_pressed("change_ship_test"):
		change_ship("ship_0001");
	
	if Input.is_action_just_pressed("test_button"):
		emit_signal("change_scene", "res://World2.tscn");
	
	fusionReactorCore.set_energy_recharge(fusionReactorCore.energy_recharge_rate * delta)

func _physics_process(delta: float) -> void:
	handle_input(delta);
	velocity = move_and_slide(velocity).clamped(playerShip.max_speed);

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

func fire_laser():
	if not equippedLaser.is_casting:
		equippedLaser.set_is_casting(true);
	
func stop_laser():
	if equippedLaser.is_casting:
		equippedLaser.set_is_casting(false);

#*********** NOT FUNCTIONING CORRECTLY/AT ALL *********
func _on_Hurtbox_area_entered(_area: Area2D) -> void:
	hurtBox.start_invincible(0.5);
	hurtBox.create_hit_effect();

func add_weapon(weapon):
	PlayerState.weapons.append(weapon);

func equip_weapon(weapon):
	equippedLaser.configure_laser(weapon)
	PlayerState.equippedLaserID = weapon;
	equippedLaser.global_position.x = laserSpawnPoint.global_position.x;
	equippedLaser.global_position.y = laserSpawnPoint.global_position.y;

func add_ship(ship : String):
	PlayerState.available_ships.append(ship);

func change_ship(ship_id : String):
	playerShip.configure_ship(ship_id);
	PlayerState.shipID = ship_id;
	playerSprite.texture = playerShip.sprite.texture;

# Any movement based input should be placed here. Function then called in _physics_process()
func handle_input(delta):
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
	
	#	# Rotation using keyboard
#	if Input.is_action_pressed("ui_left"):
#		rotate_left(delta);
#	elif Input.is_action_pressed("ui_right"):
#		rotate_right(delta);
	
	# ********ONLY NEEDED FOR ALTERNATE CONTROL STYLE ***********
# ********NEED TESTING RE: WHICH IS BETTER? KEYBOARD ROTATE VS FOLLOW MOUSE *********
#func rotate_left(delta):
#	rotation_degrees -= playerShip.rotation_speed * delta;
#	clamp_rotation();
#
#func rotate_right(delta):
#	rotation_degrees += playerShip.rotation_speed * delta;
#	clamp_rotation();

#func clamp_rotation():
#	rotation_degrees = fmod(rotation_degrees, 360)
