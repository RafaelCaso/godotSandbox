extends Node2D

onready var sprite = $Sprite;
onready var station_menu = $StationMenu;
onready var docking_tween = $DockingTween;
onready var docking_port = $Sprite/DockingPort;

var location_name = "Deep Space Earth";
var laser_scene : LaserBeam;
var rotation_speed : float = 0.1;
var docked_rotation_offset = 0.0;
var is_docking_tween_active = false;

var player_in_station = false;
var is_docked = false;
var player = null;
var laser_timer : Timer = null;

func _ready() -> void:
	laser_scene = LaserBeam.new("laser_0004", "player");
	add_child(laser_scene);
	laser_scene.global_position = self.global_position;
	laser_timer = Timer.new();
	var _connect_laser_timer = laser_timer.connect("timeout", self, "_on_LaserTimer_timeout");
	add_child(laser_timer);
	

func _process(delta) -> void:
	sprite.rotation += rotation_speed * delta;
	if is_docked and not is_docking_tween_active:
		player.global_position = docking_port.global_position;
		
		var angle_to_center = atan2(
			player.global_position.y - sprite.global_position.y,
			player.global_position.x - sprite.global_position.x
		)
		
		player.rotation = angle_to_center + PI/2;
		
		
func repair_ship():
	PlayerState.repair_ship(10);
	

func _on_Timer_timeout() -> void:
	repair_ship();



func _on_LaserCoverage_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		var enemy = body;
		shoot_at_enemy(enemy);
		laser_timer.start(2);

func _on_LaserCoverage_body_exited(body: Node) -> void:
	if body.is_in_group("enemies"):
		stop_shooting();

func shoot_at_enemy(enemy : Node):
	var laser_direction = enemy.global_position - laser_scene.global_position;
	var angle = atan2(laser_direction.y, laser_direction.x);
	laser_scene.global_rotation = angle + (PI/2);
	laser_scene.set_is_casting(true);

func stop_shooting():
	laser_scene.set_is_casting(false);


func _on_LaserTimer_timeout() -> void:
	stop_shooting();
	var bodies = $LaserCoverage.get_overlapping_bodies();
	for body in bodies:
		if body.is_in_group("enemies"):
			_on_LaserCoverage_body_entered(body);

func _input(event: InputEvent) -> void:
	if player_in_station and event.is_action_pressed("interact") and is_docked == false:
		is_docking_tween_active = true;
		is_docked = true;
		player.can_move = false;
		
		player.velocity = Vector2.ZERO;
		
		var angle_to_center = atan2(
			docking_port.global_position.y - sprite.global_position.y,
			docking_port.global_position.x - sprite.global_position.x
		);
		
		var target_rotation = angle_to_center + PI/2;
		
		docking_tween.interpolate_property(
			player,
			"global_position",
			player.global_position,
			docking_port.global_position,
			2.0, #duration in seconds
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
		
		docking_tween.interpolate_property(
			player,
			"rotation",
			player.rotation,
			target_rotation,
			2.0, #duration in seconds
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
		
		docking_tween.start();
	elif is_docked == true and event.is_action_pressed("interact"):
		player.velocity = Vector2.ZERO
		player.can_move = true;
		is_docked = false;
		station_menu.visible = false;
		$DockingArea/Timer.stop();

func _on_DockingTween_tween_all_completed() -> void:
	is_docking_tween_active = false;
	station_menu.visible = true;
	$DockingArea/Timer.start();
	if player.ship_type == "freighter":
		player.locations_visited.append(location_name);


func _on_DockingArea_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		player_in_station = true;
		Events.emit_signal("prompt_player", "Press 'E' to Commence Docking")
		player = area.get_parent();


func _on_DockingArea_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		player_in_station = false;
