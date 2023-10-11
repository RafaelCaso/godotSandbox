extends Control

var remote_ship_scene = preload("res://src/Ships/RemoteControlledShip.tscn");



func _on_Button_button_up() -> void:
	var remote_ship = remote_ship_scene.instance();
	get_tree().current_scene.add_child(remote_ship);
