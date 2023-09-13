extends Node


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			resume_game();
		else:
			pause_game();


func pause_game():
	get_tree().paused = true;

func resume_game():
	get_tree().paused = false;
