extends CanvasLayer

onready var energyUI = $EnergyUI;
onready var energyBar = $EnergyBar;
onready var shieldsUpSprite = $ShieldsUpSprite;
onready var tacticalMenu = $TacticalMenu;

func _ready() -> void:
	Events.connect("shields_toggled", self, "_toggle_shield_sprite");
	Events.connect("tactical_menu_toggled", self, "_toggle_tactical_menu")
func _on_Player_energy_changed(new_energy) -> void:
	Hud.energyBar._on_Player_energy_changed(new_energy);

func _toggle_shield_sprite():
	shieldsUpSprite.visible = not shieldsUpSprite.visible;

func _toggle_tactical_menu():
	tacticalMenu.visible =! tacticalMenu.visible;
