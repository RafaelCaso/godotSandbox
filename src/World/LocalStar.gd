extends Area2D

var player_in_danger = false;



func _on_LocalStar_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		Events.emit_signal("warn_player", "WARNING! SEVERE THERMAL RADIATION DAMAGE")
		player_in_danger = true;
		$Timer.start();

func _on_LocalStar_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		$Timer.stop();
		player_in_danger = false;
	

func _on_Timer_timeout() -> void:
	Events.emit_signal("warn_player", "WARNING! SEVERE THERMAL RADIATION DAMAGE")
	PlayerState.damage_ship(10)

