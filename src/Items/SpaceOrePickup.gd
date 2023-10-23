extends KinematicBody2D

const DRAG := 0.98;

var velocity = Vector2();
var magnet_speed = 3;

func _physics_process(_delta: float) -> void:
	velocity *= DRAG;
	var _movement = move_and_slide(velocity)

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		PlayerState.ore_stock += 1;
		queue_free();


func _on_magnet_body_entered(body: KinematicBody2D) -> void:
	if body.is_in_group("player"):
		var direction = body.global_position - global_position;
		velocity = direction * magnet_speed;


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		PlayerState.ore_stock += 1;
		queue_free();


func _on_magnet_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var direction = area.global_position - global_position;
		velocity = direction * magnet_speed;
