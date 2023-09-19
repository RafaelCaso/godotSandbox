extends Node

onready var pausedSprite = $PausedSprite;

func _ready() -> void:
	position_paused_sprite();

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			resume_game();
		else:
			pause_game();


func pause_game():
	pausedSprite.visible = true;
	get_tree().paused = true;

func resume_game():
	pausedSprite.visible = false;
	get_tree().paused = false;

func position_paused_sprite():
	var viewport_size = get_viewport().size;
	pausedSprite.position.x = viewport_size.x / 1.04 - pausedSprite.texture.get_width() / 1.04;
	pausedSprite.position.y = viewport_size.y / 4 - pausedSprite.texture.get_height() / 2;
	
