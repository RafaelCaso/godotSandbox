extends Node

const SHIP_DATA = {
	"ship_0000" : {
		"name" : "The Prototype",
		"type" : "fighter",
		"weapon_capacity" : 4,
		"texture_path": "res://Ships/0014SpaceShip.png",
		"thrust" : 10,
		"deceleration_speed" : 1000,
		"strafe_force" : 500,
		"max_speed" : 1000,
		"thrust_energy_consumption" : 15,
		"rotation_speed": 400,
	},
	
	"ship_0001" : {
		"name" : "The Enterprise",
		"type" : "destroyer",
		"weapon_capacity": 9,
		"texture_path": "res://Ships/0024USSEnterprise.png",
		"thrust" : 1000,
		"deceleration_speed" : 10000,
		"strafe_force" : 5000,
		"max_speed" : 10000,
		"thrust_energy_consumption" : 150,
		"rotation_speed": 200,
	},
	
	"ship_0002" : {
		"name" : "Freighter 1",
		"type" : "freighter",
		"weapon_capacity" : 0,
		"texture_path" : "res://0034FreightShip.png",
		"thrust" : 5,
		"deceleration_speed" : 100,
		"strafe_force" : 75,
		"max_speed" : 100,
		"thrust_energy_consumption" : 15,
		"rotation_speed": 100,
	}
}
