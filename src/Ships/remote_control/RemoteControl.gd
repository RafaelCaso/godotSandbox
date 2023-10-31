extends Node2D
class_name RemoteControl

const weapons_target_area2d_base = preload("res://src/Ships/remote_control/WeaponsTargetArea2D.tscn");

# for offense
var weapons_target_area2d : Area2D;
var weapons_target;
var weapons_target_position;
var firing : bool = false;

# for movement
var target_coordinate : Vector2;

# for commands
var in_command_mode : bool = false;
var current_command : String = "" 
var ship_uuid : String = ""

signal command_issued(coords, uuid, command)
signal weapons_target_acquired(target_acquired)

enum {
	PATROL,
	MOVE_TO_POSITION,
	ORBIT,
	ATTACK,
	DEFEND,
	FOLLOW,
	IDLE
}

var state = IDLE;

func _ready() -> void:
	Events.connect("command_given", self, "handle_command_given")
	weapons_target_area2d = weapons_target_area2d_base.instance();
	weapons_target_area2d.collision_mask = 4;
#	print(weapons_target_area2d.get_child(0).shape.radius)
	var _wrta = weapons_target_area2d.connect("body_entered", self, "_on_weapons_target_body_entered");
	var _wrta2 = weapons_target_area2d.connect("body_exited", self, "_on_weapons_target_body_exited")
	add_child(weapons_target_area2d)
	
func _on_weapons_target_body_exited(body):
	if body == weapons_target:
		weapons_target = null

func _on_weapons_target_body_entered(body):
	if body.is_in_group("enemies"):
		weapons_target = body;

func _physics_process(_delta: float) -> void:
	if weapons_target and is_instance_valid(weapons_target):
		emit_signal("weapons_target_acquired", weapons_target)
	match state:
		MOVE_TO_POSITION:
			pass

func _input(event: InputEvent) -> void:
	if in_command_mode and current_command == "MOVE_TO_POSITION" and event.is_action_pressed("laser"):
		target_coordinate = get_global_mouse_position();
		emit_signal("command_issued", target_coordinate, ship_uuid, current_command)
		in_command_mode = false;
	if in_command_mode and current_command == "ORBIT" and event.is_action_pressed("laser"):
		target_coordinate = get_global_mouse_position()
		emit_signal("command_issued", target_coordinate, ship_uuid, current_command)
		in_command_mode = false
	if in_command_mode and current_command == "ATTACK" and event.is_action_pressed("laser"):
		target_coordinate = get_global_mouse_position()
		emit_signal("command_issued", target_coordinate, ship_uuid, current_command)
		in_command_mode = false;
	if in_command_mode and current_command == "FOLLOW":
		in_command_mode = false;
		emit_signal("command_issued", null, ship_uuid, current_command);

func handle_command_given(command, ship, _optionals):
	in_command_mode = true;
	ship_uuid = ship;
	change_state(command);

func change_state(command):
	if command == "PATROL":
		state = PATROL;
		current_command = "PATROL"
	elif command == "MOVE_TO_POSITION":
		state = MOVE_TO_POSITION;
		current_command = "MOVE_TO_POSITION"
	elif command == "ATTACK":
		state = ATTACK;
		current_command = "ATTACK"
	elif command == "DEFEND":
		state = DEFEND;
		current_command = "DEFEND"
	elif command == "FOLLOW":
		state = FOLLOW;
		current_command = "FOLLOW"
	elif command == "ORBIT":
		state = ORBIT;
		current_command = "ORBIT"
	elif command == "IDLE":
		state = IDLE;
		current_command = "IDLE"
	else:
		printerr("Unrecognized command passed to remote_control: ", command)
