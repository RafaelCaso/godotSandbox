# Base laser class that other lasers inherit from.
# Configure laser by adding to the LaserDirectory.gd
# Casts a laser along a raycast, emitting particles on the impact point.
# Use `is_casting` to make the laser fire and stop.
# You can attach it to a weapon or a ship; the laser will rotate with its parent.
extends RayCast2D

const laserConfig = preload("res://src/Weapons/LaserDirectory.gd");

# Speed at which the laser extends when first fired, in pixels per seconds.
var cast_speed := 2000.0
# Maximum length of the laser in pixels.
var max_length := 400.0
# Base duration of the tween animation in seconds.
var growth_time := 0.1

var laser_energy_consumption := 25;
var laser_damage = 1;

var path = "res://Weapons/Laser.tscn";

# If `true`, the laser is firing.
# This is the primary method to fire laser
var is_casting := false setget set_is_casting
var velocity : Vector2 = Vector2.ZERO;

onready var fill := $FillLine2D
onready var tween := $Tween
onready var casting_particles := $CastingParticles2D
onready var collision_particles := $CollisionParticles2D
onready var hitbox_area := $Area2D/CollisionShape2D;
onready var line_width: float = fill.width


func _ready() -> void:
	set_physics_process(false)
	fill.points[1] = Vector2.ZERO
	hitbox_area.call_deferred("set", "disabled", true)


func _physics_process(delta: float) -> void:
	cast_to = (cast_to + Vector2.RIGHT * cast_speed * delta).clamped(max_length)
	cast_beam()

func configure_laser(laser):
	if laser in laserConfig.LASER_DATA:
		var laser_data = laserConfig.LASER_DATA[laser];
		cast_speed = laser_data["cast_speed"];
		max_length = laser_data["max_length"];
		growth_time = laser_data["growth_time"]
		laser_damage = laser_data["laser_damage"];
		set_laser_color(laser_data["laser_color"])
	else:
		print("Error: Laser key not found in LASER_DATA")

# set is_casting = true to fire laser
func set_is_casting(cast: bool) -> void:
	is_casting = cast

	if is_casting:
		cast_to = Vector2.ZERO
		fill.points[1] = cast_to
		appear()
		
		
		
		
	else:
		collision_particles.emitting = false
		disappear()
		

	set_physics_process(is_casting)
	casting_particles.emitting = is_casting


# Controls the emission of particles and extends the Line2D to `cast_to` or the ray's 
# collision point, whichever is closest.
func cast_beam() -> void:
	var cast_point := cast_to.clamped(max_length);

	force_raycast_update()
	collision_particles.emitting = is_colliding()

	if is_colliding():
		cast_point = to_local(get_collision_point())
		collision_particles.global_rotation = get_collision_normal().angle()
		hitbox_area.position = cast_point;
		var body = get_collider();
		if body.is_in_group("enemies"):
			body.stats.health -= laser_damage;

	collision_particles.position.x = cast_point.x;
	collision_particles.position.y = cast_point.y;
	collision_particles.emitting = true;
	fill.points[1] = cast_point
	
	

func appear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", 0, line_width, growth_time * 2)
	tween.start()
	hitbox_area.call_deferred("set", "disabled", false)
	
	

func disappear() -> void:
	if tween.is_active():
		tween.stop_all()

	hitbox_area.call_deferred("set", "disabled", true)
	fill.width = 0;
	
func shoot_in_direction(direction: Vector2):
	velocity = direction * cast_speed;

# for use in laser subclasses to set laser color. For now, by default, there will be no gradient between casting and colliding particles
func set_laser_color(hexcode):
	casting_particles.process_material.set("color", hexcode)
	collision_particles.process_material.set("color", hexcode)
	collision_particles.process_material.set("hue_variation", 0)
	fill.gradient = null;
	fill.default_color = hexcode;
