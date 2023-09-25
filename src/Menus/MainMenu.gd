extends Control





func _on_NewGameBtn_button_up() -> void:
	GameManager.goto_scene("res://src/World/World.tscn");


func _on_LoadGameBtn_button_up() -> void:
	PersistanceManager.load_game();


func _on_QuitGameBtn_button_up() -> void:
	get_tree().quit();
