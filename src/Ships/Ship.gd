class_name Ship extends Node



const shipConfig = preload("res://src/Ships/ShipDirectory.gd")

onready var sprite = $Sprite;
onready var area2D = $Area2D;


var uuid : String;

var classID : String;
var thrust : float;
var deceleration_speed : float;
var strafe_force : float;
var velocity = Vector2();
var max_speed : float;
var thrust_energy_consumption : float;
var weapon_capacity : int;
var locations_visited : Array;
# ONLY NEEDED FOR ALTERNATE CONTROL SETTING
var rotation_speed : float;

# When player acquires a new ship it will be instantiated using Ship.new() and automatically assigned
# a universally unique identifier and stored in PlayerState.fleet 
#func _init(new_ship_classID):
#	self.classID = new_ship_classID;
#	self.uuid = FleetManager.assign_uuid();
#	FleetManager.add_ship(self);

func configure_ship(config_classID):
	if config_classID in shipConfig.SHIP_DATA:
		var ship_data = shipConfig.SHIP_DATA[config_classID];
		sprite.texture = load(ship_data["texture_path"]);
		rotation_speed = ship_data["rotation_speed"];
		thrust = ship_data["thrust"];
		deceleration_speed = ship_data["deceleration_speed"];
		strafe_force = ship_data["strafe_force"];
		max_speed = ship_data["max_speed"];
		thrust_energy_consumption = ship_data["thrust_energy_consumption"];
		weapon_capacity = ship_data["weapon_capacity"];
		classID = config_classID;
		PlayerState.currentShipID = classID;
	else:
		print("Error: Ship key not found in SHIP_DATA");
