extends "res://src/Cameras/ShakeCamera.gd"

var zoom_speed = 0.1;
var max_zoom = Vector2(5,5);
var min_zoom = Vector2(0.5, 0.5);

var paused_sprite_fixed_offset = Vector2(0, -100);
var prompt_player_fixed_offset = Vector2(0, 500);

func _ready() -> void:
	var _pauseConnection = GameManager.connect("game_paused", self, "_on_game_paused");
	var _unpauseConnection = GameManager.connect("game_unpaused", self, "_on_game_unpaused");
	var _shakeCameraConnection = Events.connect("player_hit", self, "_on_Player_hit" );

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var zoom_change = Vector2(0,0);
		if Input.is_action_just_pressed("zoom_in"):
			
			
			zoom_change = Vector2(-zoom_speed, -zoom_speed);
		
		if Input.is_action_just_pressed("zoom_out"):
			zoom_change = Vector2(zoom_speed, zoom_speed)
			
		zoom += zoom_change;
		zoom.x = clamp(zoom.x, min_zoom.x, max_zoom.x)
		zoom.y = clamp(zoom.y, min_zoom.y, max_zoom.y)

func _on_game_paused():
	var paused_sprite_adjusted_offset = paused_sprite_fixed_offset * zoom.y;
	$PausedSprite.global_position = global_position + paused_sprite_adjusted_offset;
	$PausedSprite.scale = Vector2(1,1) * self.zoom;
	$PausedSprite.visible = true;

func _on_game_unpaused():
	$PausedSprite.visible = false;

func _on_Player_hit():
	shake(1.0, 15, 8);
