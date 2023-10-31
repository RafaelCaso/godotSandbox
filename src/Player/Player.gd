class_name Player
extends Node

onready var playerShip : Ship = null;

#var bolt = preload("res://src/Weapons/PlasmaBolt.tscn");

var weapon_pressed = false;

var velocity = Vector2();
var can_move = true;
var taking_damage = false;

func _ready() -> void:
	$Radar/CanvasLayer/RadarUI.player = self;
	var _connectPlayerNoHealthRevamp = Events.connect("no_health", self, "destroy_ship")
	var _connectShipChanged = Events.connect("active_ship_changed", self, "handle_ship_change");
	var _connectAddRemoteShip = Events.connect("add_remote_ship", self, "add_remote_ship");
	
	if PlayerState.active_ship == null:
		#initialize and configure player ship
		playerShip = Ship.new("ship_0000");
		add_child(playerShip)
		PlayerState.active_ship = playerShip;
		$Radar.global_position = PlayerState.active_ship.global_position;

	else:
		playerShip = PlayerState.active_ship;
		$Radar.global_position = PlayerState.active_ship.global_position;
	
	var _test_ship = Ship.new("ship_0001");
	var _test_ship2 = Ship.new("ship_0002");
	var _test_ship3 = Ship.new("ship_0005");

func destroy_ship(ship_to_destroy : Ship):
	if ship_to_destroy == PlayerState.active_ship:
		#*******GAME OVER LOGIC************
		self.queue_free();
	FleetManager.remove_ship(ship_to_destroy.uuid)
	ship_to_destroy.queue_free();

func add_remote_ship(ship_key):
	var remote_ship : Ship = FleetManager.get_ship(ship_key);
	remote_ship.is_remote = true;
	add_child(remote_ship);

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("test_button"):
		GameManager.goto_scene("res://World2.tscn");

func _physics_process(delta: float) -> void:
	playerShip.handle_physics_process(delta)






func add_weapon(weapon):
	PlayerState.weapons.append(weapon);



#func handle_item_input(_delta):
#	# Checks if an item is being selected by the player (physical keys 1-9)
#	for i in range(1,10):
#		if Input.is_action_just_pressed("item" + str(i)):
#			weapon_pressed = true;
#			break
#	# equips corresponding weapon if player clicks physical key 1-9
#	if weapon_pressed:
#		#********* Implemented playerShip.weapon_capacity but still loads intial laser even if weapon_capacity = 0 **********
#		for i in range(1, playerShip.weapon_capacity + 1):
#			var action_name = "item" + str(i);
#			if Input.is_action_just_pressed(action_name):
#				if i -1 < PlayerState.weapons.size():
#					equip_weapon(PlayerState.weapons[i-1]);
#				else:
#					Events.emit_signal("prompt_player", "No item equipped in slot " + str(i));
#				weapon_pressed = false;
#				break;

#func handle_input(delta):
#	handle_movement_input(delta);
#	handle_item_input(delta);


# called when Events.emit_signal("active_ship_changed") emitted
func handle_ship_change():
	var current_pos = playerShip.global_position
	remove_child(playerShip)
	playerShip = PlayerState.active_ship;
	playerShip.global_position = current_pos;
	add_child(playerShip)


#func fire_bolt():
#	var bolt_instance = bolt.instance();
#	add_child(bolt_instance);
#	bolt_instance.global_position = laserSpawnPoint.global_position;
#	bolt_instance.calculate_direction();
