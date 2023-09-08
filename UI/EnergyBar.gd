extends TextureProgress

func _on_Player_energy_changed(new_energy) -> void:
	value = new_energy;
