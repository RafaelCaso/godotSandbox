extends KinematicBody2D

var speed = 400  # This is just an example speed value.
var direction = Vector2()

# This function sets the direction of the missile based on the target.
func set_direction(target_pos):
	direction = (target_pos - global_position).normalized()

func _physics_process(delta):
	move_and_slide(direction * speed)
