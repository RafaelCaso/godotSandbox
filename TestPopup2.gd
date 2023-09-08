extends Control

onready var nameBox = $WindowDialog/NameBox
onready var popup = $WindowDialog
onready var chooseBtn = $Button
onready var okBtn = $WindowDialog/Button
onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var names = ["Adrian", "Benjamin", "Charlie", "Douglas", "Edgar"]
	for name in names:
		nameBox.add_item(name)



func _on_choose_Button_button_up() -> void:
	popup.popup();



func _on_ok_Button_button_up() -> void:
	popup.hide()
	label.text = "You have selected " + nameBox.get_item_text(nameBox.selected) 
