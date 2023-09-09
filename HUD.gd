extends CanvasLayer

onready var energyUI = $EnergyUI;
onready var energyBar = $EnergyBar;

	

func _on_Player_energy_changed(new_energy) -> void:
	Hud.energyBar._on_Player_energy_changed(new_energy);
#	Hud.energyBar.text = str(int(new_energy)) + "%";
#	energyUI.value = new_energy;
