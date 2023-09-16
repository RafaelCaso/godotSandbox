extends "res://Weapons/Laser.gd"


# How much damage the laser does to the player on hit
export var damage_amount = 1

# Function to check if the laser is colliding with the player
func _physics_process(delta):
	if is_colliding():
		var collider = get_collider()
		if collider and collider.is_in_group("player"):
			if not collider.hurtBox.invincible:
				print(collider.hurtBox.invincible)
				PlayerStats.health -= damage_amount
				var Explosion = load("res://Effects/Explosion.tscn");
				var explosion = Explosion.instance();
				var world = get_tree().current_scene;
				world.add_child(explosion);
				explosion.global_position = collider.global_position;
				# If you want the laser to disappear or be destroyed after hitting:
				# queue_free()
