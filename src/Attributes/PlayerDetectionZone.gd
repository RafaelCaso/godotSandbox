extends Area2D


var player = null;

func can_see_player():
	return player != null;

func _on_PlayerDetectionZone_body_entered(body: Node) -> void:
	player = body;


func _on_PlayerDetectionZone_body_exited(_body: Node) -> void:
	player = null;



func _on_PlayerDetectionZone_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		player = area.get_parent();


func _on_PlayerDetectionZone_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		player = null;
