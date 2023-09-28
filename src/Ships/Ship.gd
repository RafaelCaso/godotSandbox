class_name Ship extends Node



const ship_class_directory = preload("res://src/Ships/ShipDirectory.gd")

onready var sprite = $Sprite;
onready var area2D = $Area2D;


var uuid : String;

var classID : String;
var thrust : float;
var deceleration_speed : float;
var strafe_force : float;
var max_speed : float;
var thrust_energy_consumption : float;
var weapon_capacity : int;
# ONLY NEEDED FOR ALTERNATE CONTROL SETTING
var rotation_speed : float;

var velocity = Vector2();
var locations_visited : Array;

# When player acquires a new ship it will be instantiated using Ship.new() and automatically assigned
# a universally unique identifier and stored in PlayerState.fleet 
#func _init(new_ship_classID):
#	self.classID = new_ship_classID;
#	self.uuid = FleetManager.assign_uuid();
#	FleetManager.add_ship(self);

func _init(object_classID) -> void:
	self.uuid = FleetManager.assign_uuid();
	self.classID = object_classID;
	configure_ship(self)
	FleetManager.add_ship(self);

func configure_ship(body : Ship):
	if body.classID in ship_class_directory.SHIP_DATA:
		var ship_data = ship_class_directory.SHIP_DATA[body.classID];
		body.sprite = load(ship_data["texture_path"]);
		body.thrust = ship_data["thrust"];
		body.deceleration_speed = ship_data["deceleration_speed"];
		body.strafe_force = ship_data["strafe_force"];
		body.max_speed = ship_data["max_speed"];
		body.thrust_energy_consumption = ship_data["thrust_energy_consumption"];
		body.weapon_capacity = ship_data["weapon_capacity"];
	else:
		print("Error: Ship key not found in SHIP_DATA");
