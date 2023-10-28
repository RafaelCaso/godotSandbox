extends Node2D
class_name RemoteControl

var target_coordinate : Vector2;
var in_command_mode : bool = false;
var current_command : String = "" 
var ship_uuid : String = ""

signal command_issued(coords, uuid, command)

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

func _physics_process(delta: float) -> void:
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

func handle_command_given(command, ship, optionals):
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
