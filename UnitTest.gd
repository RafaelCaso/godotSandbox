extends Node

onready var formation_tween = $FormationTween;

var enemies = [];

var formation_spacing = 300;
var previous_leader_position = Vector2();

func _ready() -> void:
	for child in get_children():
		if child.is_in_group("enemies"):
			enemies.append(child);
			child.connect("enemy_died", self, "_on_Enemy_died", [child])
	update_formation();

func _on_Enemy_died(enemy):
	enemies.erase(enemy);

func update_formation():
	var leader = enemies[0];
	var movement_direction = leader.global_position - previous_leader_position
	
	var is_moving_horizontally = abs(movement_direction.x) > abs(movement_direction.y)
	
	for i in range (1, len(enemies)):
		var follower = enemies[i];
		var target_position;
		if is_moving_horizontally:
			target_position = leader.global_position + Vector2(0, formation_spacing * i)
		else:
			target_position = leader.global_position + Vector2(formation_spacing * i, 0);
		
		formation_tween.interpolate_property(
			follower,
			"global_position",
			follower.global_position,
			target_position,
			0.5, #seconds to animate
			formation_tween.TRANS_LINEAR,
			formation_tween.EASE_IN_OUT
		)
		
		formation_tween.start();
		
		previous_leader_position = leader.global_position

func _process(_delta: float) -> void:
	if enemies.size() > 0:
		update_formation()
