class_name Ship 
extends KinematicBody2D

const ship_class_directory = preload("res://src/Ships/ShipDirectory.gd")

var uuid : String;

var sprite : Sprite = null;
var sprite_texture;
var collision_shape = null
var ship_name : String;
var classID : String;
var ship_type : String;
var thrust : float;
var deceleration_speed : float;
var strafe_force : float;
var max_speed : float;
var thrust_energy_consumption : float;
var laser_capacity : int;
var carrying_capacity : int;
# ONLY NEEDED FOR ALTERNATE CONTROL SETTING
var rotation_speed : float;
var fusion_reactor_core : FusionReactorCore;
var velocity = Vector2();
var locations_visited : Array;

var ship_max_health : float setget set_max_health
var current_health : float setget set_current_health

var can_move : bool = true;

var equipped_lasers := [];

var remote_transform : RemoteTransform2D = null;
var connected_camera_path = "";

var is_remote : bool = false;

var target_position : Vector2 = Vector2();
var orbit_center : Vector2 = Vector2();
var orbit_distance := 400.0;
var traveling : bool = false;
var orbiting : bool = false;
var firing : bool = false;
var action_after_traveling = "";
var target : Node = null;
var orbit_speed = 1;

var laser;
var laser_spawn_point_1;
# When player acquires a new ship it will be instantiated using Ship.new() and automatically assigned
# a universally unique identifier and stored in PlayerState.fleet 
# ********** May need to refactor -> Maybe don't want to add EVERY instantiated ship to fleet? *************
func _init(object_classID) -> void:
	self.uuid = FleetManager.assign_uuid();
	self.classID = object_classID;
	self.set_collision_layer_bit(1, true);
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
		self.laser_capacity = ship_data["laser_capacity"];
		self.carrying_capacity = ship_data["carrying_capacity"];
		self.fusion_reactor_core = FusionReactorCore.new(ship_data["frc"])
		self.collision_shape = load((ship_data["collision_shape"]))
		self.laser_spawn_point_1 = load((ship_data["lsp1"]))

	FleetManager.add_ship(self);

func _ready() -> void:
	var _connectSpeedSlider = Events.connect("speed_slider_changed", self, "handle_speed_slider")
	var _connectPlayerNoHealthRevamp = Events.connect("no_health", self, "queue_free")
	add_to_group("player")
	
	sprite = Sprite.new();
	add_child(sprite);
	sprite.texture = sprite_texture
	
	var collision_instance = collision_shape.instance();
	add_child(collision_instance)
	
	remote_transform = RemoteTransform2D.new();
	add_child(remote_transform);
	Events.connect("connect_camera", self, "connect_camera")
	
	laser = LaserBeam.new("laser_0001", "player");
	var lsp1 = laser_spawn_point_1.instance();
	add_child(lsp1);
	laser.global_position = lsp1.global_position
	add_child(laser);
	
	
func connect_camera(camera_path):
	remote_transform.remote_path = camera_path;
	
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position();
	var direction_to_mouse = (mouse_pos - global_position);

	if can_move:
		rotation = direction_to_mouse.angle() + PI/2;
	fusion_reactor_core.set_energy_recharge(fusion_reactor_core.energy_recharge_rate * delta)

func _physics_process(delta: float) -> void:
	velocity = move_and_slide(velocity).clamped(max_speed);
	if is_remote:
		handle_remote_movement(delta);
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
				target_position = Vector2();
				traveling = false;
				if action_after_traveling == "orbit":
					var dir_to_ship = (global_position - orbit_center).normalized();
					global_position = orbit_center + dir_to_ship * orbit_distance
					orbiting = true;

func handle_physics_process(delta):
	handle_movement(delta);
	

func handle_remote_movement(delta):
	if Input.is_action_just_pressed("laser"):
		target_position = get_global_mouse_position();
		traveling = true;
		orbiting = false;
		action_after_traveling = "stop";
	
	elif Input.is_action_just_pressed("missile"):
		orbit_center = get_global_mouse_position();
		var dir_to_ship = (global_position - orbit_center).normalized();
		target_position = orbit_center + dir_to_ship * orbit_distance
		traveling = true;
		orbiting = false;
		action_after_traveling = "orbit";
	
	if Input.is_action_just_pressed("interact"):
		if firing:
			laser.set_is_casting(false)
			firing = false;
		elif not firing:
			firing = true
			var laser_target = get_global_mouse_position().rotated(rotation)
			if target and is_instance_valid(target):
				laser.look_at(target.global_position);
			else:
				laser.look_at(laser_target)
			laser.set_is_casting(true)

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
		fusion_reactor_core.deplete_energy(laser.laser_energy_consumption * delta)
		if fusion_reactor_core.has_energy(25):
			fire_laser()
		else:
			Events.emit_signal("warn_player", "Lasers are offline!")
	else:
		stop_laser()

func fire_laser():
	if not laser.is_casting:
		laser.set_is_casting(true);

func stop_laser():
		if laser.is_casting:
			laser.set_is_casting(false);

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
	
	if current_health == 0:
		Events.emit_signal("no_health", self);

func increase_current_health(change_value):
	if current_health != ship_max_health:
		Events.emit_signal("prompt_player", "Repairing Ship...");
		current_health = min(current_health + change_value, ship_max_health);

#func add_laser(laser_to_equip : LaserBeam):
#	if equipped_lasers.size() < laser_capacity:
#		equipped_lasers.append(laser_to_equip);
#	else:
#		Events.emit_signal("warn_player", "Cannot equip. This ship's weapons bay is at capacity!")
#
#func remove_laser(laser_to_unequip : LaserBeam):
#	if equipped_lasers.has(laser_to_unequip):
#		equipped_lasers.erase(laser_to_unequip);

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
