extends Node2D


func _ready():
	print("new world loaded")
	PlayerState.active_ship = PlayerState.temp_ship_container;
	PlayerState.temp_ship_container = null;
