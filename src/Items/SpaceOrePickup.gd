extends KinematicBody2D

const DRAG := 0.98;

var velocity = Vector2();

func _physics_process(_delta: float) -> void:
	velocity *= DRAG;
	var _movement = move_and_slide(velocity)

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		PlayerState.ore_stock += 1;
		print(PlayerState.ore_stock);
		queue_free();
