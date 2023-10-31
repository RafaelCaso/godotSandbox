class_name Ship 
extends KinematicBody2D

const ship_class_directory = preload("res://src/Ships/ShipDirectory.gd")

var uuid : String;

var sprite : Sprite = null;
var sprite_texture;
var collision_shape = null;
var ship_name : String;
var classID : String;
var ship_type : String;
var thrust : float;
var deceleration_speed : float;
var strafe_force : float;
var max_speed : float;
var thrust_energy_consumption : float;
var carrying_capacity : int;
# ONLY NEEDED FOR ALTERNATE CONTROL SETTING
var rotation_speed : float;
var fusion_reactor_core : FusionReactorCore;
var weapons_bay : WeaponsBay;
var remote_control : RemoteControl;
var radar : Radar;
var shield : Shield;

var velocity = Vector2();
var locations_visited : Array;

var ship_max_health : float setget set_max_health
var current_health : float setget set_current_health

var can_move : bool = true;


var remote_transform : RemoteTransform2D = null;
var connected_camera_path = "";

var is_remote : bool = false;
var weapons_target;

var target_position : Vector2 = Vector2();
var orbit_center : Vector2 = Vector2();
var orbit_distance := 400.0;
var traveling : bool = false;
var orbiting : bool = false;
var firing : bool = false;
var following : bool = false;
var action_after_traveling = "";
var target : Node = null;
var orbit_speed = 1;

#var laser;
var laser_spawn_points_scene;

var sufficient_energy : bool;

# When player acquires a new ship it will be instantiated using Ship.new() and automatically assigned
# a universally unique identifier and stored in PlayerState.fleet 
# ********** May need to refactor -> Maybe don't want to add EVERY instantiated ship to fleet? *************
func _init(object_classID) -> void:
	self.uuid = FleetManager.assign_uuid();
	self.classID = object_classID;
	if object_classID in ship_class_directory.SHIP_DATA:
		var ship_data = ship_class_directory.SHIP_DATA[object_classID];
		self.ship_name = ship_data["ship_name"];
		self.ship_type = ship_data["ship_type"];
		self.ship_max_health = ship_data["ship_max_health"];
		self.current_health = ship_max_health;
		self.sprite_texture = load(ship_data["texture_path"]);
		self.thrust = ship_data["thrust"];
		self.deceleration_speed = ship_data["deceleration_speed"];
		self.strafe_force = ship_data["strafe_force"];
		self.max_speed = ship_data["max_speed"];
		self.thrust_energy_consumption = ship_data["thrust_energy_consumption"];
		self.weapons_bay = WeaponsBay.new(self);
		self.weapons_bay.laser_capacity = ship_data["laser_capacity"];
		self.fusion_reactor_core = FusionReactorCore.new(ship_data["frc"])
		self.carrying_capacity = ship_data["carrying_capacity"];
		self.collision_shape = load((ship_data["collision_shape"]))
		self.laser_spawn_points_scene = load((ship_data["lsp1"]))
		
		var laser_spawn_points_instance = laser_spawn_points_scene.instance()
		var laser_spawn_points = laser_spawn_points_instance.get_spawn_points()
		weapons_bay.set_positions(laser_spawn_points)
		
	FleetManager.add_ship(self);

func _ready() -> void:
	var _connectSpeedSlider = Events.connect("speed_slider_changed", self, "handle_speed_slider")
	var _connectWeaponsBayToFRC = weapons_bay.connect("firing", self, "handle_weapons_fire")
	self.add_to_group("player")
	
	self.sprite = Sprite.new();
	add_child(sprite);
	self.sprite.texture = self.sprite_texture
	
	var collision_instance : Area2D = collision_shape.instance();
	collision_instance.collision_layer = 2
	add_child(collision_instance)
	
	remote_transform = RemoteTransform2D.new();
	add_child(remote_transform);
	Events.connect("connect_camera", self, "connect_camera")
	
	shield = Shield.new();
	var _shsc = shield.connect("shield_hit", self, "on_shield_hit");
	add_child(shield)
	
	add_child(weapons_bay)
	# BELOW SHOULD MOVE TO INIT?

	
	#***NOT SURE IF 'ELSE' STATEMENT IS NECESSARY. MY CONCERN IS TAKING CONTROL
	# OF A SHIP THAT WAS PREVIOUSLY SET TO REMOTE
	if is_remote:
		add_to_group("remote");
		remote_control = RemoteControl.new();
		var _rcsc = remote_control.connect("command_issued", self, "handle_command_issued")
		var _rcsc2 = remote_control.connect("weapons_target_acquired", self, "update_weapons_target")
		add_child(remote_control)
	else:
# ******* GOTTA FIGURE OUT HOW TO ADD RADAR IN SCRIPT
#		radar = Radar.new();
#		add_child(radar)
		is_remote = false;


func update_weapons_target(pos):
	if is_instance_valid(pos):
		weapons_target = pos;

func on_shield_hit():
	self.fusion_reactor_core.deplete_energy(15)
	if self.fusion_reactor_core.energy <= 35:
		shield.shield_offline();


func handle_weapons_fire(change_value):
	if self.fusion_reactor_core.has_energy(change_value):
		self.fusion_reactor_core.deplete_energy(change_value)

func connect_camera(camera_path):
	self.remote_transform.remote_path = camera_path;
	
func _process(delta: float) -> void:
	if fusion_reactor_core.has_energy(25):
		sufficient_energy = true;
	else:
		sufficient_energy = false;

	var mouse_pos = get_global_mouse_position();
	var direction_to_mouse = (mouse_pos - global_position);

	if can_move:
		if ! is_remote:
			rotation = direction_to_mouse.angle() + PI/2;

	fusion_reactor_core.set_energy_recharge(fusion_reactor_core.energy_recharge_rate * delta)

func _physics_process(delta: float) -> void:
	velocity = move_and_slide(velocity).clamped(max_speed);
	if is_remote:
		if orbiting:
			var angle_change = orbit_speed * delta;
		
			var current_angle = (global_position - orbit_center).angle() + angle_change;
		
			var new_pos = orbit_center + Vector2(cos(current_angle), sin(current_angle)) * orbit_distance;
		
			global_position = new_pos;
			look_at(orbit_center);
			rotation += PI/2;
# MOVE_TO_POSITION
		if traveling:
			var direction = (target_position - global_position).normalized();
			var move_distance = max_speed * delta;
			rotation = direction.angle() + (PI/2);

			if global_position.distance_to(target_position) > move_distance:
				global_position += direction * move_distance;
			else:
				global_position = target_position
				traveling = false;
				if action_after_traveling == "orbit":
					var dir_to_ship = (global_position - orbit_center).normalized();
					global_position = orbit_center + dir_to_ship * orbit_distance
					orbiting = true;
				if action_after_traveling == "attack":
					firing = true;
		if firing and is_instance_valid(weapons_target):
			rotation = (weapons_target.global_position - global_position).angle() + (PI/2)
			self.weapons_bay.fire(delta);
		else:
			self.weapons_bay.cease_fire();
		
		if following:
			var dir_to_player = (PlayerState.active_ship.global_position - self.global_position).normalized();
			var move_distance = max_speed * delta;
			if global_position.distance_to(PlayerState.active_ship.global_position) > 400:
				global_position += (dir_to_player * move_distance);
				rotation = dir_to_player.angle() + (PI/2);



func handle_physics_process(delta):
	if can_move:
		handle_movement(delta);

func handle_command_issued(coords, command_ship_uuid, command):
	if command_ship_uuid == self.uuid:
		if command == "MOVE_TO_POSITION":
			target_position = coords
			traveling = true;
			orbiting = false;
			following = false;
			action_after_traveling = "stop";
		if command == "ORBIT":
			orbit_center = coords;
			var dir_to_ship = (global_position - orbit_center).normalized();
			target_position = orbit_center + dir_to_ship * orbit_distance
			traveling = true;
			orbiting = false;
			following = false;
			action_after_traveling = "orbit"
		if command == "ATTACK":
			target_position = coords;
			traveling = true;
			orbiting = false;
			following = false;
			action_after_traveling = "attack"
		if command == "FOLLOW":
			following = true

func handle_movement(delta):
	# Forward Propulsion
	if Input.is_action_pressed("main_propulsion"):
		if fusion_reactor_core.has_energy(20):
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
	
	if Input.is_action_pressed("laser"):
		if can_move:
			weapons_bay.fire(delta)
	else:
		weapons_bay.cease_fire();
	
	if Input.is_action_just_pressed("missile"):
		if can_move:
			var mouse_pos = get_global_mouse_position();
			weapons_bay.missile_fire(mouse_pos)
	
	if Input.is_action_just_pressed("shields"):
		if shield.shields_active:
			shield.shields_down();
			self.fusion_reactor_core.set_max_energy(fusion_reactor_core.original_max_energy)
		else:
			shield.shields_up();
			self.fusion_reactor_core.set_max_energy(75)


func main_propulsion(delta, hasSufficientEnergy):
	# Convert the current rotation to a vector2 direction and apply forward thrust
	var main_thrust;
	if hasSufficientEnergy:
		main_thrust = thrust;
	else:
		main_thrust = thrust / 5;
	var direction = Vector2(0, -1).rotated(rotation)
	velocity += direction * main_thrust
	fusion_reactor_core.deplete_energy(thrust_energy_consumption * delta)

#***** I DON'T THINK ANY OF THESE ARE NECESSARY EXCEPT FOR INCREASE_CURRENT_HEALTH
#***** WHICH SHOULD BE MOVED TO PLAYERSTATE
func set_max_health(max_limit_value):
	ship_max_health = max_limit_value;

func set_current_health(current_health_value):
	current_health = current_health_value;

func decrease_current_health(change_value):
	current_health = clamp(current_health - change_value, 0 , ship_max_health);
	
	if current_health <= 0:
		Events.emit_signal("no_health", self);

func increase_current_health(change_value):
	if current_health != ship_max_health:
		Events.emit_signal("prompt_player", "Repairing Ship...");
		current_health = min(current_health + change_value, ship_max_health);

func handle_speed_slider(speed_val):
	max_speed = speed_val
# This might be redundant. Functionality moved to init
# Can't think of a reason to use this function
#func configure_ship(body : Ship):
#	if body.classID in ship_class_directory.SHIP_DATA:
#		var ship_data = ship_class_directory.SHIP_DATA[body.classID];
#		body.ship_name = ship_data["ship_name"];
#		body.ship_type = ship_data["ship_type"];
#		body.ship_max_health = ship_data["ship_max_health"];
#		# **This will likely need to change or else every time the ship is loaded it will reset to max health
#		body.current_health = body.ship_max_health;
#		body.sprite = load(ship_data["texture_path"]);
#		body.thrust = ship_data["thrust"];
#		body.deceleration_speed = ship_data["deceleration_speed"];
#		body.strafe_force = ship_data["strafe_force"];
#		body.max_speed = ship_data["max_speed"];
#		body.thrust_energy_consumption = ship_data["thrust_energy_consumption"];
#		body.weapon_capacity = ship_data["weapon_capacity"];
#		body.carrying_capacity = ship_data["carrying_capacity"];
#	else:
#		print("Error: Ship key not found in SHIP_DATA");


#	# ********ONLY NEEDED FOR ALTERNATE CONTROL STYLE ***********
## ********NEED TESTING RE: WHICH IS BETTER? KEYBOARD ROTATE VS FOLLOW MOUSE *********
## ******* CERTAIN SHIPS USE THIS EG. CARRIERS, DESTROYERS ********
#func rotate_left(delta):
#	rotation_degrees -= playerShip.rotation_speed * delta;
#
#func rotate_right(delta):
#	rotation_degrees += playerShip.rotation_speed * delta;
