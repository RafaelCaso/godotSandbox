extends Node2D

# this should probably reference PlayerState singleton
var player_state = {};


func change_scene(new_scene_path):
	
	var new_scene = load(new_scene_path).instance();
	add_child(new_scene);
	
	remove_child(self)


func _on_Player_change_scene(new_scene_path) -> void:
	var new_scene = load(new_scene_path).instance();
	get_tree().root.add_child(new_scene);
	get_tree().current_scene = new_scene;
	get_tree().root.remove_child(self);
	
