extends Control


onready var popup = $ConfirmationDialog
onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass




func _on_ConfirmationDialog_confirmed() -> void:
	GameManager.goto_scene("res://World2.tscn")


func _on_Area2D_area_entered(_area: Area2D) -> void:
	popup.popup();
	popup.set_global_position(sprite.global_position)
	


func _on_Area2D_area_exited(_area: Area2D) -> void:
	popup.hide();
