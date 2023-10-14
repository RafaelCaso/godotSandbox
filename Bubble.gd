extends KinematicBody2D

var charging : bool = false
var charged : bool = false;
var speed = 300
var animation_speed : float;
var mouse_pos : Vector2;
var direction : Vector2;
var velocity = Vector2.ZERO;
var trapped_body : Node = null;

func _physics_process(delta: float) -> void:

	
	charge(delta);
#
	if charged:
		velocity = move_and_collide(direction * delta * speed)
		play_animation();

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		print("bubble hit enemy")
		charged = false;
		$Sprite.frame = 0;
		$Tween.interpolate_property(
			self,
			"global_position",
			self.global_position,
			body.global_position,
			0.4,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
		
		$Tween.start()
		$Sprite.stop();
#		global_position = body.global_position;
		velocity = Vector2.ZERO;
		body.can_move = false;
		trapped_body = body;
		$Timer.start();


func charge(delta):
	if Input.is_action_pressed("missile"):
		charged = false;
		charging = true;
		if $Sprite.scale < Vector2(4,4):
			speed -= 1;
			$Sprite.scale += Vector2(1, 1) * delta;
			$Area2D.scale += Vector2(1, 1) * delta;
			$Area2D/CollisionShape2D.scale += Vector2(1, 1) * delta;
	if Input.is_action_just_released("missile") and charging:
		animation_speed = speed * 0.007;
		mouse_pos = get_global_mouse_position();
		direction = (mouse_pos - global_position).normalized();
		charged = true;
		charging = false;

func play_animation():
	$Sprite.play("play");
	$Sprite.speed_scale = animation_speed;


func _on_Timer_timeout() -> void:
	trapped_body.can_move = true;
	queue_free()

func set_direction(target_pos):
	direction = (target_pos - global_position).normalized();
