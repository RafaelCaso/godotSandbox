extends Node


# warning-ignore:unused_signal
signal shields_toggled(shield_is_active);
# warning-ignore:unused_signal
signal tactical_menu_toggled();
# warning-ignore:unused_signal
signal command_menu_toggled;
# warning-ignore:unused_signal
signal speed_slider_changed(speed_cap)
# warning-ignore:unused_signal
signal add_remote_ship(ship_key)

# warning-ignore:unused_signal
signal prompt_player(message);
# warning-ignore:unused_signal
signal warn_player(message);
# warning-ignore:unused_signal
signal player_effect(effect_name);
# warning-ignore:unused_signal
signal player_hit();

# warning-ignore:unused_signal
signal no_health(destroyed_ship);
# warning-ignore:unused_signal
signal active_ship_changed;
# warning-ignore:unused_signal
signal connect_camera(remote_path)
