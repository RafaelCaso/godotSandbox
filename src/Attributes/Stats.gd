extends Node

export var max_health = 10 setget set_max_health;
var health = max_health setget set_health;

signal no_health;
signal health_changed(value);
signal max_health_changed(value);

func heal(heal_value):
	if heal_value <= 0:
		return;
	if health < max_health:
		health = min(health + heal_value, max_health);
		Events.emit_signal("prompt_player", "Repairing Ship...")
		emit_signal("health_changed", health)


func set_health(value):
	health = value;
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health");

func set_max_health(value):
	max_health = value;
	self.health = min(health, max_health);
	emit_signal("max_health_changed")

func _ready() -> void:
	self.health = max_health;
