extends Area2D

var asteroid_icon = preload("res://Assets/Sprites/Radar/radar_asteroid.png");
var enemy_icon = preload("res://Assets/Sprites/Radar/radar_enemy.png");
var station_icon = preload("res://Assets/Sprites/Radar/radar_station.png");
var warp_gate_icon = preload("res://Assets/Sprites/Radar/radar_warp_gate.png");

onready var radarUI = $CanvasLayer/RadarUI;


#***** MAKE SURE AREA2D IS SET TO COLLIDE WITH THESE OBJECTS (MASK SETTING) ****
func _on_Radar_body_entered(body: Node) -> void:
	if body.is_in_group("asteroid"):
		radarUI.add_object(body, asteroid_icon);
	elif body.is_in_group("enemies"):
		radarUI.add_object(body, enemy_icon);
	elif body.is_in_group("station"):
		print("Station entered radar")
		radarUI.add_object(body, station_icon);
	elif body.is_in_group("warpgate"):
		print("Warpgate entered radar")
		radarUI.add_object(body, warp_gate_icon); 
