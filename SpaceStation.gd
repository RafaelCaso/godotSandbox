extends Node2D

onready var sprite = $Sprite;
onready var laser_scene = $LaserBeam2D;

var rotation_speed : float = 0.1;

func _ready() -> void:
	laser_scene.configure_laser("laser_0004");
	laser_scene.global_position = self.global_position;

func _process(delta) -> void:
	sprite.rotation += rotation_speed * delta;

func repair_ship():
	PlayerStats.heal(1);

func _on_Timer_timeout() -> void:
	repair_ship();


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		$DockingArea/Timer.start();


func _on_Area2D_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		$DockingArea/Timer.stop();


func _on_LaserCoverage_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		var enemy = body;
		shoot_at_enemy(enemy);
		$LaserBeam2D/LaserTimer.start();

func _on_LaserCoverage_body_exited(body: Node) -> void:
	if body.is_in_group("enemies"):
		stop_shooting();

func shoot_at_enemy(enemy : Node):
	laser_scene.look_at(enemy.global_position);
	laser_scene.is_casting = true;

func stop_shooting():
	laser_scene.is_casting = false;


func _on_LaserTimer_timeout() -> void:
	stop_shooting();
	var bodies = $LaserCoverage.get_overlapping_bodies();
	for body in bodies:
		if body.is_in_group("enemies"):
			_on_LaserCoverage_body_entered(body);
	
	
