extends Area2D

var player_in_danger = false;
var entered_ship = null;


func _on_LocalStar_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		entered_ship = body;
		Events.emit_signal("warn_player", "WARNING! SEVERE THERMAL RADIATION DAMAGE")
		player_in_danger = true;
		$Timer.start();

func _on_LocalStar_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		$Timer.stop();
		player_in_danger = false;
	

func _on_Timer_timeout() -> void:
	Events.emit_signal("warn_player", "WARNING! SEVERE THERMAL RADIATION DAMAGE")
	if entered_ship:
		PlayerState.damage_ship(10, entered_ship)



func _on_LocalStar_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		entered_ship = area.get_parent();
		Events.emit_signal("warn_player", "WARNING! SEVERE THERMAL RADIATION DAMAGE")
		player_in_danger = true;
		$Timer.start();


func _on_LocalStar_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		$Timer.stop();
		player_in_danger = false;
