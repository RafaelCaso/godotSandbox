extends Node


var ships = {};

func add_ship(ship):
	PlayerState.fleet[ship.uuid] = ship;
	
func get_ship(ship_uuid):
	return PlayerState.fleet.get(ship_uuid, null);

func remove_ship(ship_uuid):
	PlayerState.fleet.erase(ship_uuid);

func generate_uuid() -> String:
	var chars = "0123456789ABCDEF"
	var uuid = ""
	for _i in range(8):
		uuid += chars[randi() % chars.length()]
	uuid += "-"
	for _i in range(4):
		uuid += chars[randi() % chars.length()]
	uuid += "-4"
	for _i in range(3):
		uuid += chars[randi() % chars.length()]
	uuid += "-A"
	for _i in range(3):
		uuid += chars[randi() % chars.length()]
	uuid += "-"
	for _i in range(12):
		uuid += chars[randi() % chars.length()]
	return uuid

func assign_uuid():
	var uuid = generate_uuid()
	while PlayerState.fleet.has(uuid):
		uuid = generate_uuid();
	return uuid;
