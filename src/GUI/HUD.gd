extends CanvasLayer

onready var energyUI = $EnergyUI;
onready var energyBar = $EnergyBar;
onready var shieldsUpSprite = $ShieldsUpSprite;
onready var tacticalMenu = $TacticalMenu;
onready var playerPrompt = $MarginContainer/PlayerPrompt;

func _ready() -> void:
	Events.connect("shields_toggled", self, "_toggle_shield_sprite");
	Events.connect("tactical_menu_toggled", self, "_toggle_tactical_menu");
	Events.connect("prompt_player", self, "_on_player_prompt");
	Events.connect("player_effect", self, "_on_player_effect");
func _on_Player_energy_changed(new_energy) -> void:
	Hud.energyBar._on_Player_energy_changed(new_energy);

func _toggle_shield_sprite():
	shieldsUpSprite.visible = not shieldsUpSprite.visible;

func _toggle_tactical_menu():
	tacticalMenu.visible =! tacticalMenu.visible;
	tacticalMenu.close_secondary_menu();

func _on_player_prompt(message):
	$TextTimer.start()
	playerPrompt.bbcode_text = "[center]" + message + "[/center]";
	playerPrompt.rect_min_size = playerPrompt.get_size();

func _on_TextTimer_timeout() -> void:
	playerPrompt.clear();

func _on_player_effect(effect_name: String) -> void:
	var path = "Effects/%s" % effect_name
	var animatedSprite = get_node_or_null(path)
	
	if animatedSprite:
		animatedSprite.visible = true;
		animatedSprite.play_animation()
	else:
		print("Effect not found:", effect_name, path)
