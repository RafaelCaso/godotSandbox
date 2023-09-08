extends Label

func _on_Player_energy_changed(new_energy) -> void:
	text = str(int(new_energy)) + "%";
