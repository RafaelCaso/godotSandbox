class_name Ship extends Node



const shipConfig = preload("res://src/Ships/ShipDirectory.gd")

onready var sprite = $Sprite;
onready var area2D = $Area2D;

# ONLY NEEDED FOR ALTERNATE CONTROL SETTING
var rotation_speed : float;

var shipID : String;
var thrust : float;
var deceleration_speed : float;
var strafe_force : float;
var velocity = Vector2();
var max_speed : float;
var thrust_energy_consumption : float;
var weapon_capacity : int;
var locations_visited : Array;

enum {FIGHTER, FREIGHTER, CARRIER, CORVETTE}
var ship_type;

func configure_ship(ship):
	if ship in shipConfig.SHIP_DATA:
		var ship_data = shipConfig.SHIP_DATA[ship];
		sprite.texture = load(ship_data["texture_path"]);
		rotation_speed = ship_data["rotation_speed"];
		thrust = ship_data["thrust"];
		deceleration_speed = ship_data["deceleration_speed"];
		strafe_force = ship_data["strafe_force"];
		max_speed = ship_data["max_speed"];
		thrust_energy_consumption = ship_data["thrust_energy_consumption"];
		weapon_capacity = ship_data["weapon_capacity"];
		shipID = ship;
		PlayerState.currentShipID = shipID;
	else:
		print("Error: Ship key not found in SHIP_DATA");
