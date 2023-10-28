# Center for weapons Logic
# Should ONLY be instantiated in Ship class
# Or else deferred_get_parent() will not populate correctly
# Parent should always be Ship class
# Currently has missile logic, MAY NEED MISSILEBAY SCENE IN FUTURE
extends Node2D
class_name WeaponsBay

var laser_capacity : int;
var available_lasers : Array;
var laser_spawn_points : Array;
var positions : Array = [];
var parent;

var active_cluster_missile = null;
const missilePath = "res://src/Weapons/GuidedMissile.tscn"
var MissileScene = preload(missilePath)


signal firing(total_energy_used)

func _init(parent_ship) -> void:
	parent = parent_ship

func _ready() -> void:
	#***** TESTING ONLY******
	var test_laser = LaserBeam.new("laser_0001", "player")
	test_laser.is_equipped = true;
	add_child(test_laser)
	add_laser(test_laser)
#*******END TESTING ONLY BLOCK*******************************************
	
	call_deferred("_deferred_get_parent")
	call_deferred("position_lasers", available_lasers)


func set_positions(laser_positions : Array):
	for pos in laser_positions:
		positions.append(pos)
		

func position_lasers(lasers):
	var i = 1;
	for laser in lasers:
		if is_only_one_laser_equipped():
			laser.global_position = parent.global_position + positions[0];
		else:
			laser.global_position = parent.global_position + positions[i];
			i += 1;
	i = 1 # RESETTING INCASE I NEED TO CALL FUNC A SECOND TIME

func is_only_one_laser_equipped() -> bool:
	var equipped_count = 0;
	
	for laser in available_lasers:
		if laser.is_equipped:
			equipped_count += 1;
			if equipped_count > 1:
				return false
	return equipped_count == 1;

func _deferred_get_parent():
	parent = get_parent();

func fire(delta):
	for laser in available_lasers:
		if laser.is_equipped:
			emit_signal("firing", laser.laser_energy_consumption * delta)
			laser.set_is_casting(true)

func cease_fire():
	for laser in available_lasers:
		if laser.is_equipped:
			laser.set_is_casting(false)

func equip_laser(laser : LaserBeam):
	laser.is_equipped = true;

func unequip_weapon(laser : LaserBeam):
	laser.is_equipped = false;

func add_laser(laser):
	if available_lasers.size() < laser_capacity:
		available_lasers.append(laser)
	else:
		Events.emit_signal("warn_player", "Weapons Bay at Capacity! Cannot Add Weapon")

func remove_laser(laser):
	if available_lasers.has(laser):
		available_lasers.erase(laser)

func missile_fire(mouse_pos):
	if active_cluster_missile and is_instance_valid(active_cluster_missile):
		var missile_to_detonate = active_cluster_missile
		active_cluster_missile = null  # Set to null before calling detonate
		missile_to_detonate.detonate()
	elif PlayerState.missileStock > 0:
		PlayerState.missileStock -= 1
		var missile_instance = MissileScene.instance();
		if not missile_instance.has_method("detonate"):
			parent.get_parent().add_child(missile_instance);
			missile_instance.global_position = global_position;
			missile_instance.set_direction(mouse_pos)
		else:
			active_cluster_missile = missile_instance;
			parent.get_parent().add_child(active_cluster_missile);
			active_cluster_missile.global_position = global_position;
			active_cluster_missile.set_direction(mouse_pos)
	else:
		Events.emit_signal("warn_player", "No Missiles in arsenal");
