extends Node2D

onready var weapons_bay_inst = preload("res://WeaponsBay.tscn")

func _ready() -> void:
	var ship = Ship.new("ship_0000");
	PlayerState.active_ship = ship

