extends Node2D

var player_state = {};

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		print("interacting")

func change_scene(new_scene_path):
	
	var new_scene = load(new_scene_path).instance();
	add_child(new_scene);
	
	remove_child(self)


func _on_Player_change_scene(new_scene_path) -> void:
	var new_scene = load(new_scene_path).instance();
	get_tree().root.add_child(new_scene);
	get_tree().current_scene = new_scene;
	get_tree().root.remove_child(self);
	
