extends Node

signal game_paused;
signal game_unpaused;

var current_scene = null;

func _ready() -> void:
	var root = get_tree().root;
	current_scene = root.get_child(root.get_child_count() - 1);

func goto_scene(path):
	call_deferred("_deferred_goto_scene", path);

func _deferred_goto_scene(path):
	current_scene.free();
	
	var s = ResourceLoader.load(path);
	
	if s == null:
		printerr("Failed to load scene at path: " + path);
		return
	
	current_scene = s.instance();
	
	get_tree().root.add_child(current_scene);
	
	get_tree().current_scene = current_scene;

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			resume_game();
		else:
			pause_game();


func pause_game():
	get_tree().paused = true;
	emit_signal("game_paused");

func resume_game():
	get_tree().paused = false;
	emit_signal("game_unpaused");


