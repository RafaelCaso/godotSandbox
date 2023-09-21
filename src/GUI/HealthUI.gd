extends Control

var health = 4 setget set_health;
var max_health = 4 setget set_max_health;

onready var healthUI_full = $HealthUI_full
onready var healthUI_empty = $HealthUI_empty;


func set_health(value):
	health = clamp(value, 0, max_health)
	if healthUI_full != null:
		healthUI_full.rect_size.x = health * 256

func set_max_health(value):
	max_health = max(value, 1);
	self.health = min(health, max_health);
	if healthUI_empty != null:
		healthUI_empty.rect_size.x = max_health * 256;

func _ready() -> void:
	self.max_health = PlayerStats.max_health;
	self.health = PlayerStats.health;
	var _connectHealthChange = PlayerStats.connect("health_changed", self, "set_health");
	var _connectMaxHealth = PlayerStats.connect("max_health_changed", self, "set_max_health");
