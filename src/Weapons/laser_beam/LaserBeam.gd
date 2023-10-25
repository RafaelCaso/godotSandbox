extends RayCast2D
class_name LaserBeam

const laserConfig = preload("res://src/Weapons/LaserDirectory.gd");

# Component Source Files and Materials
const line2D_base = preload("res://src/Weapons/laser_beam/LaserBeamLine2D.tscn");
const line2D_gradient = preload("res://src/Weapons/laser_beam/LaserBeamLine2D.tres")
const casting_particles_base = preload("res://src/Weapons/laser_beam/CastingParticles.tscn")
const casting_particles_material = preload("res://src/Weapons/laser_beam/CastingParticles.tres")
const collision_particles_base = preload("res://src/Weapons/laser_beam/CollisionParticles.tscn")
const collision_particles_material = preload("res://src/Weapons/laser_beam/CollisionParticles.tres")
const beam_particles_base = preload("res://src/Weapons/laser_beam/BeamParticles.tscn")
const beam_particles_material = preload("res://src/Weapons/laser_beam/BeamParticles.tres")
const hitbox_base = preload("res://src/Weapons/hitbox/LaserHitbox.tscn")
const enemy_hitbox_base = preload("res://src/Weapons/hitbox/EnemyLaserHitbox.tscn")
var texture;

# firing mechanism - call this in parent scripts to fire laser
var is_casting := false setget set_is_casting

# LaserBeam components
var line2D : Line2D;
var tween : Tween;
var casting_particles : Particles2D;
var collision_particles : Particles2D;
var beam_particles : Particles2D;
var environment : WorldEnvironment;
var hitbox : Area2D;
var collision_shape : CollisionShape2D;

# configurations
var cast_speed : float;
var max_length : float;
var growth_time : float;
var laser_energy_consumption : int;
var laser_damage : int;
var laser_color : String;

# Utility variables
var is_equipped : bool;

func _init(laser_class_id, parent) -> void:
	if parent == "enemy":
		collision_mask = 2
		hitbox = enemy_hitbox_base.instance()
		hitbox.set_collision_layer_bit(2, true)
		add_child(hitbox)
		collision_shape = hitbox.get_child(0);
		collide_with_areas = true
	else:
		collision_mask = 4
		hitbox = hitbox_base.instance();
		add_child(hitbox)
		collision_shape = hitbox.get_child(0);
	
	var texture_path = "res://Assets/Sprites/Weapons/0065BeamParticle.png"
	texture = load(texture_path)
	
	line2D = line2D_base.instance()
	line2D.gradient = line2D_gradient.duplicate();
	add_child(line2D)
	
	tween = Tween.new();
	add_child(tween)
	
	#*******DUPLICATING TEXTURE NOT WORKING AS NEEDED******************
	casting_particles = casting_particles_base.instance();
	casting_particles.material = casting_particles_material.duplicate();
	casting_particles.texture = texture.duplicate();
	add_child(casting_particles)
	
	collision_particles = collision_particles_base.instance();
	collision_particles.material = collision_particles_material.duplicate();
	collision_particles.texture = texture.duplicate();
	add_child(collision_particles)
	
	beam_particles = beam_particles_base.instance();
	beam_particles.material = beam_particles_material.duplicate();
	beam_particles.texture = texture.duplicate()
	add_child(beam_particles);
	
#	environment = environment_base.instance();
#	add_child(environment);
	
	if laser_class_id in laserConfig.LASER_DATA:
		var laser_data = laserConfig.LASER_DATA[laser_class_id];
		cast_speed = laser_data["cast_speed"];
		max_length = laser_data["max_length"];
		growth_time = laser_data["growth_time"]
		laser_damage = laser_data["laser_damage"];
		laser_energy_consumption = laser_data["laser_energy_consumption"];
		laser_color = laser_data["laser_color"];
		set_laser_color(laser_color)
	
func _ready() -> void:
	cast_to = Vector2(0, -max_length)
	set_physics_process(false)
	line2D.points[1] = Vector2.ZERO
	collision_shape.call_deferred("set", "disabled", true)

func _physics_process(_delta: float) -> void:
	if is_casting:
		var cast_point := cast_to
		force_raycast_update();
		hitbox.position = cast_point
		
		if is_colliding():
			var collided_object = get_collider();
			
			#**************** THIS NEEDS TO BE HANDLED BETTER ************
			if collided_object.is_in_group("player"):
				PlayerState.damage_ship(laser_damage, collided_object.get_parent());
			else:
				collided_object.stats.health -= laser_damage;
			
			cast_point = to_local(get_collision_point())
			collision_particles.global_rotation = get_collision_normal().angle()
			collision_particles.position = cast_point
			
			hitbox.position = cast_point
		line2D.points[1] = cast_point
	#	collision_particles.emitting = is_colliding();
		collision_particles.position = cast_point
		collision_particles.emitting = true;
			

			
		line2D.points[1] = cast_point
		beam_particles.position = cast_point * 0.5
		beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5
	else:
		line2D.points[1] = Vector2.ZERO;
		collision_particles.emitting = false
	
func set_is_casting(cast : bool):
	is_casting = cast;
	
	beam_particles.emitting = is_casting;
	casting_particles.emitting = is_casting;
	
	if is_casting:
		appear();
	else:
		collision_particles.emitting = false;
		disappear();
		
	set_physics_process(cast);

func appear():
	set_laser_color(laser_color)
	collision_shape.call_deferred("set", "disabled", false)
	line2D.visible = true;
	var _tstop = tween.stop_all();
	var _tint = tween.interpolate_property(line2D, "width", 0, 10.0, 0.2);
	var _tsta = tween.start();

func disappear():
	collision_shape.call_deferred("set", "disabled", true)
	line2D.visible = false;
	var _tstop = tween.stop_all();
	var _tint = tween.interpolate_property(line2D, "width", 10.0, 0, 0.1);
	var _tsta = tween.start()

func set_laser_color(hexcode):
	casting_particles.process_material.set("color", hexcode)
	beam_particles.process_material.set("color", hexcode)
	line2D.gradient.set_color(0, hexcode)
	line2D.gradient.set_color(1, hexcode)
	collision_particles.process_material.set("color", hexcode)
	collision_particles.process_material.set("hue_variation", 0)
	line2D.default_color = hexcode;
