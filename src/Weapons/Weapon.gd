extends Node


var can_fire : bool;
var energy_consumption : float;
var cooldown_time : float;
var damage : int;

func fire():
	pass;

func start_cooldown_timer():
	can_fire = false;
	yield(get_tree().create_timer(cooldown_time), "timeout")
	can_fire = true;

