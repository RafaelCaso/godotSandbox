extends KinematicBody2D


var bolt = preload("res://src/Weapons/PlasmaBolt.tscn");


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("laser"):
		var bolt_instance = bolt.instance();
		add_child(bolt_instance);
		bolt_instance.global_position = global_position;
		bolt_instance.calculate_direction();
