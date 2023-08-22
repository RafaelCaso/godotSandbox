extends Area2D

var nearby_enemies = [];

func _ready() -> void:
	connect("area_entered", self, "_on_area_entered");
	connect("area_exited", self, "_on_area_exited");

func _on_area_entered(area: Area2D):
	if area.is_in_group("enemies"):
		nearby_enemies.append(area);
		update_formation();

func _on_area_exited(area: Area2D):
	if area in nearby_enemies:
		nearby_enemies.erase(area);
		update_formation();

func update_formation():
	var offset = 60 # space between each enemy
	var start_position = global_position - Vector2(offset * (nearby_enemies.size() - 1) * 0.5, 0)
	
	for i in range(nearby_enemies.size()):
		var target_position = start_position + Vector2(i * offset, 0)
		# use tween or lerp to move enemies to target position smoothly
		nearby_enemies[i].global_position = target_position
