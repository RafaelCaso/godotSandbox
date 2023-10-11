extends Control


onready var secondaryBG = $SecondaryBG
onready var itemList = $ItemList
onready var game_settings_menu = $GameSettings

const SHIP_DIRECTORY = preload("res://src/Ships/ShipDirectory.gd");
const LASER_DIRECTORY = preload("res://src/Weapons/LaserDirectory.gd");
const ITEM_HEIGHT = 40;

var current_open_menu : String = "none";
var ships = [];
func _ready() -> void:
	close_secondary_menu()
	
	



func _on_WeaponsBtn_button_up() -> void:
	if current_open_menu == "weapons":
		close_secondary_menu();
	else:
		game_settings_menu.visible = false;
		open_secondary_menu();
		var item_count = 0;
		for laser_key in PlayerState.weapons:
			if laser_key in LASER_DIRECTORY.LASER_DATA:
				var laser = LASER_DIRECTORY.LASER_DATA[laser_key];
				var laserName = laser["name"];
				itemList.add_item(laserName);
				item_count += 1;
		resize_itemList_rect(item_count);
		current_open_menu = "weapons";

func _on_ShipsBtn_button_up() -> void:
	if current_open_menu == "ships":
		close_secondary_menu()
	else:
		game_settings_menu.visible = false;
		open_secondary_menu();
		var item_count = 0;
		for ship_key in PlayerState.fleet:
			var ship = FleetManager.get_ship(ship_key)
			if ship.classID in SHIP_DIRECTORY.SHIP_DATA:
				itemList.add_item(ship.ship_name);
				ships.append(ship)
				item_count += 1;
		resize_itemList_rect(item_count);
		current_open_menu = "ships";
	
func _on_GameBtn_button_up() -> void:
	if current_open_menu == "game_settings":
		close_secondary_menu();
	else:
		itemList.visible = false;
		open_secondary_menu();
		game_settings_menu.visible = true;
		current_open_menu = "game_settings";

func open_secondary_menu():
	itemList.clear();
	secondaryBG.visible = true;
	itemList.visible = true;

func close_secondary_menu():
	itemList.clear();
	secondaryBG.visible = false;
	itemList.visible = false;
	game_settings_menu.visible = false;
	current_open_menu = "none";

func resize_itemList_rect(item_count):
	itemList.rect_min_size.y = ITEM_HEIGHT * item_count;




func _on_SaveGameBtn_button_up() -> void:
	PersistanceManager.save_game();




func _on_LoadGameBtn_button_up() -> void:
	PersistanceManager.load_game();


func _on_QuitGameBtn_button_up() -> void:
	get_tree().quit();


func _on_ItemList_item_selected(index: int) -> void:
	#*******THIS IS TRIGGERING FOR BOTH WEAPONS AND SHIPS WHICH CAUSES CRASH*********
	#******LOOK INTO MENUBTN********	
	var selected_ship = ships[index];
	PlayerState.active_ship = selected_ship;
	Events.emit_signal("active_ship_changed");
#	var change_to_ship = FleetManager.get_ship(selected_ship.uuid);

	
	
