extends Control

onready var main_menu = $ColorRect/MainMenu;
onready var secondary_menu = $ColorRect/SecondaryMenu;
onready var item_list = $ColorRect/SecondaryMenu/ItemList;

onready var ships_btn = $ColorRect/MainMenu/ShipsBtn;
onready var weapons_btn = $ColorRect/MainMenu/WeaponsBtn;
onready var crew_btn = $ColorRect/MainMenu/CrewBtn;
onready var resources_btn = $ColorRect/MainMenu/ResourcesBtn;

const SHIP_DIRECTORY = preload("res://src/Ships/ShipDirectory.gd");
const LASER_DIRECTORY = preload("res://src/Weapons/LaserDirectory.gd");

const ITEM_HEIGHT = 40;

var current_open_menu : String = "none";

var ship_ids = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _on_ShipsBtn_button_up() -> void:
	if current_open_menu == "ships":
		close_secondary_menu();
	else:
		open_secondary_menu();
		current_open_menu = "ships";
		ship_ids.clear();
		item_list.clear();
		var item_count = 0;
		for ship_key in SHIP_DIRECTORY.SHIP_DATA:
			var ship = SHIP_DIRECTORY.SHIP_DATA[ship_key];
			var ship_name = ship["ship_name"];
			ship_ids.append(ship_key);
			item_list.add_item(ship_name);
			item_count += 1;
		resize_itemList_rect(item_count);

func open_secondary_menu():
	secondary_menu.visible = true;
	main_menu.visible = false;
	$ColorRect/Label.visible = false;

func close_secondary_menu():
	secondary_menu.visible = false;

func resize_itemList_rect(item_count):
	item_list.rect_min_size.y = ITEM_HEIGHT * item_count;


func _on_ItemList_item_selected(index: int) -> void:
	var selected_ship_id = ship_ids[index];
	var _new_ship = Ship.new(selected_ship_id);
	

func _on_RepairShipBtn_button_up() -> void:
	PlayerState.missileStock += 10;


func _on_CrewBtn_button_up() -> void:
	pass
