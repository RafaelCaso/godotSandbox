extends Node2D

const LOOT_SPEED = 80;

var ore_scene = preload("res://src/Items/SpaceOrePickup.tscn")


func _ready() -> void:
	var amount_to_generate = generate_loot();
	for _i in range(amount_to_generate):
		var ore_instance = ore_scene.instance();
		scatter_ore(ore_instance);
		call_deferred("add_child", ore_instance);
		ore_instance.global_position = global_position;
		
	
func generate_loot():
	randomize();
	var loot_amount = 0
	while loot_amount == 0:
		loot_amount = randi() % 4;
	return loot_amount

func scatter_ore(ore_instance : KinematicBody2D):
	#random angle between 0 and 2PI
	var angle = randf() * 2 * PI;
	var direction = Vector2(cos(angle), sin(angle))
	ore_instance.velocity = direction * LOOT_SPEED;
