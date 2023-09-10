extends Node

const shipConfig = preload("res://Ships/ShipDirectory.gd")

onready var sprite = $Sprite;

# ONLY NEEDED FOR ALTERNATE CONTROL SETTING
var rotation_speed : float;

var thrust : float;
var deceleration_speed : float;
var strafe_force : float;
var velocity = Vector2();
var max_speed : float;
var thrust_energy_consumption : float;
var shipID : String;

func configure_ship(ship):
	if ship in shipConfig.SHIP_DATA:
		var ship_data = shipConfig.SHIP_DATA[ship];
		sprite.texture = load(ship_data["texture_path"]);
		thrust = ship_data["thrust"];
		deceleration_speed = ship_data["deceleration_speed"];
		strafe_force = ship_data["strafe_force"];
		max_speed = ship_data["max_speed"];
		thrust_energy_consumption = ship_data["thrust_energy_consumption"];
		shipID = ship;
	else:
		print("Error: Ship key not found in SHIP_DATA");
