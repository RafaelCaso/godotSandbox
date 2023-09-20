extends CanvasLayer

onready var energyUI = $EnergyUI;
onready var energyBar = $EnergyBar;
onready var shieldsUpSprite = $ShieldsUpSprite;

func _ready() -> void:
	shieldsUpSprite.connect("shields_toggled", self, "_toggle_shield_sprite");

func _on_Player_energy_changed(new_energy) -> void:
	Hud.energyBar._on_Player_energy_changed(new_energy);
#	Hud.energyBar.text = str(int(new_energy)) + "%";
#	energyUI.value = new_energy;

func _toggle_shield_sprite():
	shieldsUpSprite.visible = not shieldsUpSprite.visible;
