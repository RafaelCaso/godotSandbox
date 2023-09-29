class_name Ship extends Node



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

var velocity = Vector2();
var locations_visited : Array;

# When player acquires a new ship it will be instantiated using Ship.new() and automatically assigned
# a universally unique identifier and stored in PlayerState.fleet 
# ********** May need to refactor -> Maybe don't want to add EVERY instantiated ship to fleet? *************
func _init(object_classID) -> void:
	self.uuid = FleetManager.assign_uuid();
	self.classID = object_classID;
	configure_ship(self)
	FleetManager.add_ship(self);

# match classID to ship_directory and assign all values to ship passed into function
func configure_ship(body : Ship):
	if body.classID in ship_class_directory.SHIP_DATA:
		var ship_data = ship_class_directory.SHIP_DATA[body.classID];
		body.ship_name = ship_data["ship_name"];
		body.ship_type = ship_data["ship_type"];
		body.sprite = load(ship_data["texture_path"]);
		body.thrust = ship_data["thrust"];
		body.deceleration_speed = ship_data["deceleration_speed"];
		body.strafe_force = ship_data["strafe_force"];
		body.max_speed = ship_data["max_speed"];
		body.thrust_energy_consumption = ship_data["thrust_energy_consumption"];
		body.weapon_capacity = ship_data["weapon_capacity"];
		body.carrying_capacity = ship_data["carrying_capacity"];
	else:
		print("Error: Ship key not found in SHIP_DATA");
