extends Control


onready var sprite = $Sprite

func _on_Area2D_area_entered(_area: Area2D) -> void:
	Events.emit_signal("prompt_player", "Press 'E' To Enter Warp Gate")
