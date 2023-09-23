extends CanvasLayer

export(Texture) var empty_cursor = null;

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta: float) -> void:
	$Sprite.global_position = $Sprite.get_global_mouse_position()
