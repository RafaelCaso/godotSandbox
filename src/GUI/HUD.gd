extends CanvasLayer

onready var energyText = $EnergyText;
onready var energyBar = $EnergyBar;
onready var shieldsUpSprite = $ShieldsUpSprite;
onready var tacticalMenu = $TacticalMenu;
onready var playerPrompt = $MarginContainer/PlayerPrompt;
onready var healthProgress = $HealthProgress;
onready var commandMenu = $CommandMenu;
onready var commandList = $CommandMenu/ColorRect/VBoxContainer
onready var speedSlider = $HSlider

func _ready() -> void:
	Events.connect("shields_toggled", self, "_toggle_shield_sprite");
	Events.connect("tactical_menu_toggled", self, "_toggle_tactical_menu");
	Events.connect("prompt_player", self, "_on_player_prompt");
	Events.connect("warn_player", self, "_on_player_warn");
	Events.connect("player_effect", self, "_on_player_effect");
	var _health_change_connection = PlayerState.connect("ship_health_changed", self, "handle_health_changed");
	Events.connect("active_ship_changed", self, "handle_ship_changed");
	Events.connect("command_menu_toggled", self, "handle_command_menu")
	call_deferred("handle_ship_changed")
	speedSlider.tick_count = 5

	
func _process(_delta: float) -> void:
	if Input.is_action_pressed("toggleup"):
		speedSlider.value += 10;
	if Input.is_action_pressed("toggledown"):
		speedSlider.value -= 10;
# what on Earth is going on here?
func _on_Player_energy_changed(new_energy) -> void:
	Hud.energyBar._on_Player_energy_changed(new_energy);

# this needs to change or be called differently
# problem is when player changes this will be the inverse of shield status
func _toggle_shield_sprite():
	shieldsUpSprite.visible = not shieldsUpSprite.visible;

func _toggle_tactical_menu():
	tacticalMenu.visible =! tacticalMenu.visible;
	tacticalMenu.close_secondary_menu();

func _on_player_prompt(message):
	$TextTimer.start()
	playerPrompt.bbcode_text = "[center]" + message + "[/center]";
	playerPrompt.rect_min_size = playerPrompt.get_size();

func _on_player_warn(message):
	$TextTimer.start()
	playerPrompt.bbcode_text = "[color=#ff0000][center]" + message + "[/center][/color]";
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

func handle_health_changed(current_health):
	healthProgress.max_value = PlayerState.active_ship.ship_max_health;
	adjust_health_tween(current_health);
	$HealthText.text = str(PlayerState.active_ship.current_health) + "/" + str(PlayerState.active_ship.ship_max_health);

func adjust_health_tween(target_value):
	$HealthProgress/Tween.stop_all();
	$HealthProgress/Tween.interpolate_property(healthProgress, "value", healthProgress.value, target_value, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$HealthProgress/Tween.start();

func handle_ship_changed():
	healthProgress.max_value = PlayerState.active_ship.ship_max_health;
	healthProgress.value = PlayerState.active_ship.current_health;
	$HealthText.text = str(PlayerState.active_ship.current_health) + "/" + str(PlayerState.active_ship.ship_max_health);
	speedSlider.max_value = PlayerState.active_ship.max_speed
	speedSlider.value = speedSlider.max_value

func handle_command_menu():
	if commandMenu.visible:
		commandMenu.visible = false;
		clear_command_list();
		
	else:
		commandMenu.visible = true;
		for ship_key in PlayerState.fleet:
			var ship : Ship = FleetManager.get_ship(ship_key);
			if ship != PlayerState.active_ship and not ship in commandList:
				var button = Button.new();
				button.text = ship.ship_name;
				button.rect_size = Vector2(100, 20)
				button.connect("button_up", self, "handle_command_btn", [ship_key])
				commandList.add_child(button)

func handle_command_btn(ship_key):
	Events.emit_signal("add_remote_ship", ship_key);

func clear_command_list():
	for child in commandList.get_children():
		child.queue_free();

func _on_HSlider_value_changed(value: float) -> void:
	Events.emit_signal("speed_slider_changed", value)
