class_name Player
extends KinematicBody2D



onready var playerShip : Ship = null;
onready var laserSpawnPoint = $LaserSpawnPoint;
#onready var energyShield = $EnergyShield;

const missilePath = "res://src/Weapons/GuidedMissile.tscn"
var MissileScene = preload(missilePath)

var bolt = preload("res://src/Weapons/PlasmaBolt.tscn");

var weapon_pressed = false;

var active_cluster_missile = null;

var velocity = Vector2();
var can_move = true;
var taking_damage = false;

func _ready() -> void:
	$Radar/CanvasLayer/RadarUI.player = self;
#	var _connectPlayerNoHealth = PlayerStats.connect("no_health", self, "queue_free");
	var _connectPlayerNoHealthRevamp = Events.connect("no_health", self, "queue_free")
	var _connectShipChanged = Events.connect("active_ship_changed", self, "handle_ship_change");
#	energyShield.connect("shield_hit", self, "on_shield_hit")
	
	if PlayerState.active_ship == null:
		#initialize and configure player ship
		playerShip = Ship.new("ship_0000");
		add_child(playerShip)
		PlayerState.active_ship = playerShip;

	else:
		playerShip = PlayerState.active_ship;
#	playerShip.fusion_reactor_core.connect("energy_changed", Hud, "_on_Player_energy_changed");
	# configure ship sprite and position ship
#	playerSprite.texture = playerShip.sprite;
#	playerSprite.global_position = global_position;
	# initialize and configure ship weapon and position weapon


func _process(_delta: float) -> void:
	
#	var mouse_pos = get_global_mouse_position();
#	var _direction_to_mouse = (mouse_pos - global_position);
	
#	if can_move:
#		rotation = direction_to_mouse.angle() + PI/2;



#	if Input.is_action_just_pressed("missile") && can_move:
#		if active_cluster_missile and is_instance_valid(active_cluster_missile):
#			var missile_to_detonate = active_cluster_missile
#			active_cluster_missile = null  # Set to null before calling detonate
#			missile_to_detonate.detonate()
#		elif PlayerState.missileStock > 0:
#			PlayerState.missileStock -= 1
#			var missile_instance = MissileScene.instance();
#			if not missile_instance.has_method("detonate"):
#				get_parent().add_child(missile_instance);
#				missile_instance.global_position = laserSpawnPoint.global_position;
#				missile_instance.set_direction(mouse_pos)
#			else:
#				active_cluster_missile = missile_instance;
#				get_parent().add_child(active_cluster_missile);
#				active_cluster_missile.global_position = laserSpawnPoint.global_position;
#				active_cluster_missile.set_direction(mouse_pos)
#		else:
#			Events.emit_signal("prompt_player", "No Missiles in arsenal");
	
	if Input.is_action_just_pressed("test_button"):
		GameManager.goto_scene("res://World2.tscn");
	
#	if Input.is_action_just_pressed("shields"):
#		if energyShield.shields_active == true:
#			energyShield.shields_down();
#			playerShip.fusion_reactor_core.set_max_energy(100)
#		elif energyShield.shields_active == false:
#			playerShip.fusion_reactor_core.set_max_energy(energyShield.required_frc_energy);
#			energyShield.play_animation();
#			energyShield.shields_up()

#	playerShip.fusion_reactor_core.set_energy_recharge(playerShip.fusion_reactor_core.energy_recharge_rate * delta)

func _physics_process(delta: float) -> void:

	playerShip.handle_physics_process(delta)






func add_weapon(weapon):
	PlayerState.weapons.append(weapon);



# THIS NEEDS TO CHANGE TO ADD OBJECT REFERENCE TO PlayerState.fleet
# eg. FleetManager.add_ship(uuid)
func add_ship(ship : Ship):
	FleetManager.add_ship(ship);

# THIS NEEDS TO CHANGE TO ACCESS OBJECT REFERENCE DIRECTLY FROM PlayerState.fleet
# eg. playerShip = FleetManager.get_ship(uuid)
# NO MORE configure_ship()
func change_ship(ship_uuid : String):
	var new_ship = FleetManager.get_ship(ship_uuid);
	PlayerState.active_ship = new_ship
	playerShip = new_ship;



#func handle_item_input(_delta):
#	# Checks if an item is being selected by the player (physical keys 1-9)
#	for i in range(1,10):
#		if Input.is_action_just_pressed("item" + str(i)):
#			weapon_pressed = true;
#			break
#	# equips corresponding weapon if player clicks physical key 1-9
#	if weapon_pressed:
#		#********* Implemented playerShip.weapon_capacity but still loads intial laser even if weapon_capacity = 0 **********
#		for i in range(1, playerShip.weapon_capacity + 1):
#			var action_name = "item" + str(i);
#			if Input.is_action_just_pressed(action_name):
#				if i -1 < PlayerState.weapons.size():
#					equip_weapon(PlayerState.weapons[i-1]);
#				else:
#					Events.emit_signal("prompt_player", "No item equipped in slot " + str(i));
#				weapon_pressed = false;
#				break;

#func handle_input(delta):
#	handle_movement_input(delta);
#	handle_item_input(delta);

#func on_shield_hit():
#	playerShip.fusion_reactor_core.energy -= 50;
#	if playerShip.fusion_reactor_core.energy <= 1:
#		energyShield.shield_offline();

# called when Events.emit_signal("active_ship_changed") emitted
func handle_ship_change():
	playerShip = PlayerState.active_ship;


func fire_bolt():
	var bolt_instance = bolt.instance();
	add_child(bolt_instance);
	bolt_instance.global_position = laserSpawnPoint.global_position;
	bolt_instance.calculate_direction();

# Not being used right now, but I want to move damage functionality
# to _process so damage is continuous instead of bulk
# this will require damage values to be lowered
func take_damage(damage_value):
	PlayerState.damage_ship(damage_value);

#MOVED TO SHIP SCRIPT*************************************************
#KEEPING IN CASE SHIT HITS METAPHORICAL FAN****************************
# Any movement based input should be placed here. Function then called in _physics_process()
#func handle_movement_input(delta):
#	# Forward Propulsion
#	if Input.is_action_pressed("main_propulsion"):
#		if playerShip.fusion_reactor_core.has_energy(10):
#			main_propulsion(delta, true);
#		else:
#			main_propulsion(delta, false);
#
#	# Deceleration
#	if Input.is_action_pressed("main_deceleration"):
#		velocity = velocity.normalized() * max(0, velocity.length() - playerShip.deceleration_speed * delta)
#
#
#	# Strafe left
#	if Input.is_action_pressed("ui_left"):
#		var left_direction = Vector2(-1, 0).rotated(rotation)
#		velocity += left_direction * playerShip.strafe_force * delta;
#
#	# Strafe right
#	if Input.is_action_pressed("ui_right"):
#		var right_direction = Vector2(1, 0).rotated(rotation)
#		velocity += right_direction * playerShip.strafe_force * delta;
#
#	# Strafe down
#	if Input.is_action_pressed("strafe_down"):
#		var down_direction = Vector2(0, 1).rotated(rotation);
#		velocity += down_direction * playerShip.strafe_force * delta;

#	#	# Rotation using keyboard
#	if Input.is_action_pressed("alternate_rotate_left"):
#		rotate_left(delta);
#	elif Input.is_action_pressed("alternate_rotate_right"):
#		rotate_right(delta);
#
#	# ********ONLY NEEDED FOR ALTERNATE CONTROL STYLE ***********
## ********NEED TESTING RE: WHICH IS BETTER? KEYBOARD ROTATE VS FOLLOW MOUSE *********
## ******* CERTAIN SHIPS USE THIS EG. CARRIERS, DESTROYERS ********
#func rotate_left(delta):
#	rotation_degrees -= playerShip.rotation_speed * delta;
#
#func rotate_right(delta):
#	rotation_degrees += playerShip.rotation_speed * delta;

#func main_propulsion(delta, hasSufficientEnergy):
#	# Convert the current rotation to a vector2 direction and apply forward thrust
#	var thrust;
#	if hasSufficientEnergy:
#		thrust = playerShip.thrust;
#	else:
#		thrust = playerShip.thrust / 5;
#	var direction = Vector2(0, -1).rotated(rotation)
#	velocity += direction * thrust
#	playerShip.fusion_reactor_core.deplete_energy(playerShip.thrust_energy_consumption * delta)
