extends Node

signal ship_health_changed(current_health);

var currentShipID : String = "ship_0000";
var equippedLaserID: String = "laser_0000";
var weapons : Array = ["laser_0000"];
var missileStock : int = 10;
var fleet : Dictionary = {};
var active_ship : Ship = null;
var ore_stock : float = 0.0;

var object_selected = false;

func repair_ship(change_value):
	if active_ship:
		active_ship.increase_current_health(change_value);
		emit_signal("ship_health_changed", active_ship.current_health)
	else:
		printerr("No ship in active_ship slot");

func damage_ship(change_value):
	if active_ship:
		active_ship.decrease_current_health(change_value);
		emit_signal("ship_health_changed", active_ship.current_health)
	else:
		printerr("No ship in active_ship slot");
