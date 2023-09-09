extends Node


export var max_energy = 100 setget set_max_energy;
export var energy_recharge = 10 setget set_energy_recharge;
var energy = max_energy setget set_energy
var energy_minimum = 0;

signal no_energy;
signal has_energy;
signal energy_changed(value)
signal max_energy_changed(value)

func set_max_energy(value):
	max_energy = value;
	self.energy = min(energy, max_energy);
	emit_signal("max_energy_changed");

func set_energy(value):
	energy = clamp(value, 0, max_energy);
	emit_signal("energy_changed", energy)
	Hud.energyBar.value = value;
	if energy <= 0:
		emit_signal("no_energy")

func _ready() -> void:
	self.energy = max_energy;

func has_energy(comparison_value):
	if self.energy > comparison_value:
		emit_signal("has_energy")
		return true;
	else:
		emit_signal("no_energy");
		return false;

func set_energy_recharge(value):
	self.energy += value;

func deplete_energy(value):
	self.energy -= value;
