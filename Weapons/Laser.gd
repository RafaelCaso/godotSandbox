# Casts a laser along a raycast, emitting particles on the impact point.
# Use `is_casting` to make the laser fire and stop.
# You can attach it to a weapon or a ship; the laser will rotate with its parent.
extends RayCast2D


# Speed at which the laser extends when first fired, in pixels per seconds.
var cast_speed := 7000.0
# Maximum length of the laser in pixels.
var max_length := 400.0
# Base duration of the tween animation in seconds.
var growth_time := 0.1

var laser_energy_consumption := 25;

var path = "res://Weapons/Laser.tscn";

# If `true`, the laser is firing.
# It plays appearing and disappearing animations when it's not animating.
# See `appear()` and `disappear()` for more information.
var is_casting := false setget set_is_casting

onready var fill := $FillLine2D
onready var tween := $Tween
onready var casting_particles := $CastingParticles2D
onready var collision_particles := $CollisionParticles2D
onready var beam_particles := $BeamParticles2D
onready var hitbox_area := $Area2D/CollisionShape2D;
onready var line_width: float = fill.width



func _ready() -> void:
	set_physics_process(false)
	fill.points[1] = Vector2.ZERO
	hitbox_area.disabled = true;


func _physics_process(delta: float) -> void:
	cast_to = (cast_to + Vector2.RIGHT * cast_speed * delta).clamped(max_length)
	cast_beam()


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
	beam_particles.emitting = is_casting
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

	collision_particles.position.x = cast_point.x;
	collision_particles.position.y = cast_point.y;
	collision_particles.emitting = true;
	fill.points[1] = cast_point
	beam_particles.position = cast_point * 0.5
	beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5
	
	

func appear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", 0, line_width, growth_time * 2)
	tween.start()
	hitbox_area.disabled = false;
	
	

func disappear() -> void:
	if tween.is_active():
		tween.stop_all()

	hitbox_area.disabled = true;
	fill.width = 0;
	

# for use in laser subclasses to set laser color. For now, by default, there will be no gradient between casting and colliding particles
func set_laser_color(hexcode):
	casting_particles.process_material.set("color", hexcode)
	collision_particles.process_material.set("color", hexcode)
	collision_particles.process_material.set("hue_variation", 0)
	fill.gradient = null;
	fill.default_color = hexcode;
