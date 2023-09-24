extends AnimatedSprite

func _ready() -> void:
	self.frame = 0;

func play_animation():
	self.frame = 0;
	self.visible = true;
	self.play()


func _on_AnimatedSprite_animation_finished() -> void:
	self.visible = false;
