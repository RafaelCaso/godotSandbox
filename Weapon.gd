extends Node

var damage : int = 1;
var energy_consumption : float = 25.0;
var cooldown : float = 1.0;
var can_fire : bool = true;

signal energy_used(amount);

func fire():
	pass

func start_cooldown_timer():
	can_fire = false;
	yield(get_tree().create_timer(cooldown), "timeout")
	can_fire = true;

