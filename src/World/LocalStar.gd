extends Area2D





func _on_LocalStar_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		Events.emit_signal("warn_player", "WARNING! SEVERE THERMAL RADIATION DAMAGE")
		$Timer.start();

func _on_LocalStar_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		$Timer.stop();
	
func damage_player():
	PlayerStats.health -= 1;

func _on_Timer_timeout() -> void:
	Events.emit_signal("warn_player", "WARNING! SEVERE THERMAL RADIATION DAMAGE")
	damage_player();
