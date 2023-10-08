extends Area2D

var asteroid_icon = preload("res://Assets/Sprites/Radar/radar_asteroid.png");
var enemy_icon = preload("res://Assets/Sprites/Radar/radar_enemy.png");
var station_icon = preload("res://Assets/Sprites/Radar/radar_station.png");
var warp_gate_icon = preload("res://Assets/Sprites/Radar/radar_warp_gate.png");
var planet_icon = preload("res://Assets/Sprites/Radar/radar_planet.png");
var star_icon = preload("res://Assets/Sprites/Radar/radar_star.png");

onready var radarUI = $CanvasLayer/RadarUI;


#***** MAKE SURE AREA2D IS SET TO COLLIDE WITH THESE OBJECTS (MASK SETTING) ****
func _on_Radar_body_entered(body: Node) -> void:
	if body.is_in_group("asteroid"):
		radarUI.add_object(body, asteroid_icon);
	elif body.is_in_group("enemies"):
		radarUI.add_object(body, enemy_icon);
	elif body.is_in_group("station"):
		radarUI.add_object(body, station_icon);
	elif body.is_in_group("warpgate"):
		radarUI.add_object(body, warp_gate_icon);
	elif body.is_in_group("planet"):
		radarUI.add_object(body, planet_icon);
	elif body.is_in_group("star"):
		radarUI.add_object(body, star_icon);
