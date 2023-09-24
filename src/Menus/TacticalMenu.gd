extends Control


onready var secondaryBG = $SecondaryBG
onready var itemList = $ItemList
onready var game_settings_menu = $GameSettings

const laserData = preload("res://src/Weapons/LaserDirectory.gd");
const shipData = preload("res://src/Ships/ShipDirectory.gd");
const ITEM_HEIGHT = 40;

var current_open_menu : String = "none";

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
			if laser_key in laserData.LASER_DATA:
				var laser = laserData.LASER_DATA[laser_key];
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
		for ship_key in PlayerState.available_ships:
			if ship_key in  shipData.SHIP_DATA:
				var ship = shipData.SHIP_DATA[ship_key];
				var shipName = ship["name"];
				itemList.add_item(shipName);
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
