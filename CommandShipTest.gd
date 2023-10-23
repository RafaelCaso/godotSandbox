extends KinematicBody2D

onready var laser = $LaserBeam2D;

var target_position : Vector2 = Vector2();
var orbit_center : Vector2 = Vector2();
var orbit_distance := 400.0;
var orbit_speed = 1;
var speed : float = 400.0;
var orbiting : bool = false;
var traveling : bool = false;
var firing : bool = false;
var action_after_traveling = "";

var target : Node = null;

# SHOULD CHANGE THIS TO STATE MACHINE LOGIC

func _physics_process(delta: float) -> void:
	if orbiting:
		var angle_change = orbit_speed * delta;
		
		var current_angle = (global_position - orbit_center).angle() + angle_change;
		
		var new_pos = orbit_center + Vector2(cos(current_angle), sin(current_angle)) * orbit_distance;
		
		global_position = new_pos;
		look_at(orbit_center);
		rotation += PI/2;
		

# MOVE_TO_POSITION
	if traveling:
		var direction = (target_position - global_position).normalized();
		var move_distance = speed * delta;
		rotation = direction.angle() + (PI/2);

		if global_position.distance_to(target_position) > move_distance:
			global_position += direction * move_distance;
		else:
			global_position = target_position
			target_position = Vector2();
			traveling = false;
			if action_after_traveling == "orbit":
				var dir_to_ship = (global_position - orbit_center).normalized();
				global_position = orbit_center + dir_to_ship * orbit_distance
				orbiting = true;


func _process(_delta: float) -> void:
	set_target_position();


func set_target_position():
	if Input.is_action_just_pressed("laser"):
		target_position = get_global_mouse_position();
		traveling = true;
		orbiting = false;
		action_after_traveling = "stop";
	
	elif Input.is_action_just_pressed("missile"):
		orbit_center = get_global_mouse_position();
		var dir_to_ship = (global_position - orbit_center).normalized();
		target_position = orbit_center + dir_to_ship * orbit_distance
		traveling = true;
		orbiting = false;
		action_after_traveling = "orbit";
	
	if Input.is_action_just_pressed("interact"):
		if firing:
			laser.is_casting = false;
			firing = false;
		elif not firing:
			firing = true
			var laser_target = get_global_mouse_position()
			if target and is_instance_valid(target):
				laser.look_at(target.global_position);
			else:
				laser.look_at(laser_target)
			laser.is_casting = true;


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		target = body;
