extends Node


var ships = {};

func add_ship(ship):
	ships[ship.uuid] = ship;
	
func get_ship(ship_uuid):
	return ships.get(ship_uuid, null);

func remove_ship(ship_uuid):
	ships.erase(ship_uuid);
