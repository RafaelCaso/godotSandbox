extends Node2D
class_name RemoteControl

enum {
	PATROL,
	MOVE_TO_POSITION,
	ATTACK,
	DEFEND,
	FOLLOW,
	IDLE
}

var state = IDLE;

func _ready() -> void:
	print("remote control node loaded")

func _physics_process(delta: float) -> void:
	match state:
		PATROL:
			print("patrolling")

func handle_command(command):
	if command == "PATROL":
		state = PATROL
	elif command == "MOVE_TO_POSITION":
		state = MOVE_TO_POSITION;
