extends Node

signal ship_health_changed(current_health);

var active_ship : Ship = null;
# when changing scenes the temp_ship_container will hold a reference to the active ship 
# which will be reset when scene is loaded
var temp_ship_container : Ship = null;

var equippedLaserID: String = "laser_0000";
var weapons : Array = ["laser_0000"];
var missileStock : int = 10;
var fleet : Dictionary = {};
var ore_stock : float = 0.0;

var object_selected = false;

func repair_ship(change_value):
	if active_ship:
		active_ship.increase_current_health(change_value);
		emit_signal("ship_health_changed", active_ship.current_health)
	else:
		printerr("No ship in active_ship slot");

func damage_ship(change_value, ship_to_damage : Ship):
	if ship_to_damage.uuid in fleet:
		emit_signal("ship_health_changed", active_ship.current_health)
		ship_to_damage.decrease_current_health(change_value)
	else:
		printerr("No ship in active_ship slot");
