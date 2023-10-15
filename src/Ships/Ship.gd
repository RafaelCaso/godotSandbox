class_name Ship extends KinematicBody2D

const ship_class_directory = preload("res://src/Ships/ShipDirectory.gd")

onready var sprite = $Sprite;
onready var area2D = $Area2D;

var uuid : String;

var ship_name : String;
var classID : String;
var ship_type : String;
var thrust : float;
var deceleration_speed : float;
var strafe_force : float;
var max_speed : float;
var thrust_energy_consumption : float;
var weapon_capacity : int;
var carrying_capacity : int;
# ONLY NEEDED FOR ALTERNATE CONTROL SETTING
var rotation_speed : float;
var fusion_reactor_core : FusionReactorCore;
var velocity = Vector2();
var locations_visited : Array;

var ship_max_health : float setget set_max_health
var current_health : float setget set_current_health

var can_move : bool = true;

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
		# **This will likely need to change or else every time the ship is loaded it will reset to max health
		self.current_health = ship_max_health;
		self.sprite = load(ship_data["texture_path"]);
		self.thrust = ship_data["thrust"];
		self.deceleration_speed = ship_data["deceleration_speed"];
		self.strafe_force = ship_data["strafe_force"];
		self.max_speed = ship_data["max_speed"];
		self.thrust_energy_consumption = ship_data["thrust_energy_consumption"];
		self.weapon_capacity = ship_data["weapon_capacity"];
		self.carrying_capacity = ship_data["carrying_capacity"];
		self.fusion_reactor_core = FusionReactorCore.new(ship_data["frc"])
	FleetManager.add_ship(self);


func _physics_process(_delta: float) -> void:
	velocity = move_and_slide(velocity).clamped(max_speed);

func handle_input(delta, rotation):
	# Forward Propulsion
	if Input.is_action_pressed("main_propulsion"):
		if fusion_reactor_core.has_energy(20):
			main_propulsion(delta, true, rotation);
		else:
			main_propulsion(delta, false, rotation);
	
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

func main_propulsion(delta, hasSufficientEnergy, rotation):
	# Convert the current rotation to a vector2 direction and apply forward thrust
	var main_thrust;
	if hasSufficientEnergy:
		main_thrust = thrust;
	else:
		main_thrust = thrust / 5;
	var direction = Vector2(0, -1).rotated(rotation)
	velocity += direction * main_thrust
	fusion_reactor_core.deplete_energy(thrust_energy_consumption * delta)

func set_max_health(max_limit_value):
	ship_max_health = max_limit_value;

func set_current_health(current_health_value):
	current_health = current_health_value;

func decrease_current_health(change_value):
	current_health = clamp(current_health - change_value, 0 , ship_max_health);
	
	if current_health == 0:
		Events.emit_signal("no_health");

func increase_current_health(change_value):
	if current_health != ship_max_health:
		Events.emit_signal("prompt_player", "Repairing Ship...");
		current_health = min(current_health + change_value, ship_max_health);



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
