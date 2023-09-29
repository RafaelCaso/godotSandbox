extends Node

const SHIP_DATA = {
	"ship_0000" : {
		"ship_name" : "The Prototype",
		"ship_type" : "fighter",
		"weapon_capacity" : 4,
		"carrying_capacity" : 50,
		"texture_path": "res://Assets/Sprites/Spaceships/0014SpaceShip.png",
		"thrust" : 10,
		"deceleration_speed" : 1000,
		"strafe_force" : 500,
		"max_speed" : 1000,
		"thrust_energy_consumption" : 11,
		"rotation_speed": 400,
	},
	
	"ship_0001" : {
		"ship_name" : "The Enterprise",
		"ship_type" : "destroyer",
		"weapon_capacity": 9,
		"carrying_capacity" : 1000,
		"texture_path": "res://Assets/Sprites/Spaceships/0024USSEnterprise.png",
		"thrust" : 1000,
		"deceleration_speed" : 10000,
		"strafe_force" : 5000,
		"max_speed" : 10000,
		"thrust_energy_consumption" : 150,
		"rotation_speed": 200,
	},
	
	"ship_0002" : {
		"ship_name" : "Freighter 1",
		"ship_type" : "freighter",
		"weapon_capacity" : 0,
		"carrying_capacity" : 10000,
		"texture_path" : "res://Assets/Sprites/Spaceships/0034FreightShip.png",
		"thrust" : 5,
		"deceleration_speed" : 100,
		"strafe_force" : 75,
		"max_speed" : 100,
		"thrust_energy_consumption" : 11,
		"rotation_speed": 100,
	},
	
	"ship_0003" : {
		"ship_name" : "Carrier 1",
		"ship_type" : "Carrier",
		"weapon_capacity" : 10,
		"carrying_capacity" : 2000,
		"texture_path" : "res://Assets/Sprites/Spaceships/0052Carrier.png",
		"thrust" : 8,
		"deceleration_speed" : 100,
		"strafe_force" : 75,
		"max_speed" : 500,
		"thrust_energy_consumption" : 11,
		"rotation_speed": 100,
	}
}
