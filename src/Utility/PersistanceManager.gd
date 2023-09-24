extends Node

const SAVE_FILE_PATH : String = "user://game.save"


func save_game():
	var save_data : Dictionary = {
		"player_state" : gather_player_state(),
		"current_scene" : get_tree().current_scene.filename
	};
	
	var file = File.new();
	file.open(SAVE_FILE_PATH, File.WRITE)
	file.store_string(var2str(save_data));
	file.close();


func load_game():
	var file = File.new();
	file.open(SAVE_FILE_PATH, File.READ)
	var save_data_str = file.get_as_text()
	file.close();
	var save_data = str2var(save_data_str);

# ********* NEED TO CONVERT PLAYERSTATE INTO DICTIONARY SO I CAN LOOP THROUGH STATE WHEN LOADING 	
#	for key in save_data["player_state"].keys():
#		if PlayerState.has(key):
#			PlayerState.set(key, save_data["player_state"][key])
#		else:
#			print("Warning, key not found in PlayerState: ", key);
	
	PlayerState.currentShipID = save_data["player_state"]["currentShipID"];
	PlayerState.equippedLaserID = save_data["player_state"]["equippedLaserID"];
	PlayerState.weapons = save_data["player_state"]["weapons"];
	PlayerState.available_ships = save_data["player_state"]["available_ships"];
	PlayerState.missileStock = save_data["player_state"]["missileStock"];
		
	GameManager.goto_scene(save_data["current_scene"]);


func gather_player_state() -> Dictionary:
	var player_state = {
		"currentShipID" : PlayerState.currentShipID,
		"equippedLaserID" : PlayerState.equippedLaserID,
		"weapons" : PlayerState.weapons,
		"available_ships" : PlayerState.available_ships,
		"missileStock" : PlayerState.missileStock
	}
	
	return player_state;
