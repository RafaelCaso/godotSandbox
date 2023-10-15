extends Node
class_name FusionReactorCore

const frc_class_data = preload("res://src/Attributes/FRCDirectory.gd")

export (float) var max_energy setget set_max_energy;
export (float) var energy_recharge setget set_energy_recharge;
var energy = max_energy setget set_energy

var frc_name : String;
var uuid : String;
var classID : String;
var energy_minimum = 0;
var energy_recharge_rate;

signal no_energy;
signal has_energy;
signal energy_changed(value)
signal max_energy_changed(value)

func _init(object_classID) -> void:
	uuid = FleetManager.assign_uuid()
	classID = object_classID;
	if object_classID in frc_class_data.FRC_DATA:
		var frc_data = frc_class_data.FRC_DATA[object_classID];
		frc_name = frc_data["frc_name"]
		max_energy = frc_data["max_energy"];
		energy_recharge_rate = frc_data["energy_recharge_rate"]
	set_energy(max_energy)
	
func set_max_energy(value):
	max_energy = value;
	self.energy = min(energy, max_energy);
	emit_signal("max_energy_changed");

func set_energy(value):
	energy = clamp(value, 0, max_energy);
	emit_signal("energy_changed", energy)
	Hud.energyBar.value = value;
	Hud.energyText.text = str(int(value)) + "%";
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
