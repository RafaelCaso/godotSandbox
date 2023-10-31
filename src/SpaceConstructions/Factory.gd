extends Node2D

onready var docking_area = $DockingArea
onready var production_timer = $ProductionTimer
onready var approach_point = $Approach
onready var dock = $Dock
onready var docking_tween = $DockingTween
onready var approach_tween = $ApproachTween

var products : Array = [];
var ore_supply : int = 0;
var player_in_station : bool = false;
var is_docked : bool = false;

var is_docking_tween_active : bool = false;

var player = null;

func _ready() -> void:
	docking_area.connect("area_entered", self, "on_docking_area_entered");
	docking_area.connect("area_exited", self, "on_docking_area_exited")
	
	approach_tween.connect("tween_all_completed", self, "on_approach_tween_completed")
	docking_tween.connect("tween_all_completed", self, "on_docking_tween_completed")
	$LandingLights.visible = false;
	

func on_docking_tween_completed():
	player.can_move = false;
	player.velocity = Vector2.ZERO
	$ShieldWall.play("shield_up")
	$LandingLights.visible = false;
	player.rotation = deg2rad(225)
	
func on_approach_tween_completed():
	if is_docked:
		$Sprite2.z_index = -1;
		player.velocity = Vector2.ZERO
		docking_tween.interpolate_property(
			player,
			"global_position",
			player.global_position,
			dock.global_position,
			3.0,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
		docking_tween.start()
		player.can_move = false;
	else:
		player.can_move = true;
		$Sprite2.z_index = 0;
	
func on_docking_area_entered(area):
	if area.is_in_group("player"):
		Events.emit_signal("prompt_player", "press e to commence docking")
		player = area.get_parent();
		player_in_station = true;

func on_docking_area_exited(area):
	if area.is_in_group("player"):
		player_in_station = false;


func _input(event: InputEvent) -> void:
	if player_in_station and event.is_action_pressed("interact") and is_docked == false:
		is_docking_tween_active = true;
		is_docked = true;
		player.can_move = false;
		player.velocity = Vector2.ZERO
		var target_rotation = deg2rad(45)
		
		approach_tween.interpolate_property(
			player,
			"global_position",
			player.global_position,
			approach_point.global_position,
			2.0,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
		approach_tween.interpolate_property(
			player,
			"rotation",
			player.rotation,
			target_rotation,
			2.0,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
		approach_tween.start()
		$ShieldWall.play("shield_down")
		$Sprite3.visible = false;
		$LandingLights.visible = true;
		$LandingLights.play("landing_lights")
	
	elif is_docked == true and event.is_action_pressed("interact"):
		player.can_move = true;
		is_docked = false;
		
		approach_tween.interpolate_property(
			player,
			"global_position",
			player.global_position,
			approach_point.global_position,
			2.0,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
		approach_tween.start()
