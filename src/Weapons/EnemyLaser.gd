extends LaserBeam


# How much damage the laser does to the player on hit
export var damage_amount = 1

func _ready() -> void:
	._init("laser_0003", "enemy")

# Function to check if the laser is colliding with the player
func _physics_process(_delta):
	if is_colliding():
		var collider = get_collider()
		if collider and collider.is_in_group("player"):
			if not collider.hurtBox.invincible:
				collider.hurtBox.set_invincible(true);
				collider.hurtBox.create_hit_effect();
				PlayerState.damage_ship(10, collider)
