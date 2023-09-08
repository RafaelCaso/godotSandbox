extends Node

onready var popup = $Popup
onready var button = $Popup/Button
onready var sprite = $Sprite

func _ready() -> void:
	button.connect("pressed", self, "_button_pressed");
	button.set_global_position(sprite.global_position)

func _button_pressed():
	get_parent().get_tree().change_scene("res://World2.tscn")
	print("button pressed")

func _on_Area2D_area_entered(_area: Area2D) -> void:
	print("Area entered")
	popup.set_global_position(sprite.global_position);
	popup.popup();
	if popup && Input.is_action_just_pressed("interact"):
		print("interact button pressed")
		get_parent().get_tree().change_scene("res://World2.tscn");

func _on_Area2D_area_exited(_area: Area2D) -> void:
	print("Area exited")
	popup.hide();
