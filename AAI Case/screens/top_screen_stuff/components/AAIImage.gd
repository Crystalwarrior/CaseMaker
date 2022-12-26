extends TextureRect

const SPEED = 0.5

func add_bg_shadow():
	modulate_tween(Color(111,111,111,255))

func remove_bg_shadow():
	modulate_tween(Color(255,255,255,255))

func modulate_tween(color: Color):
	var mod_tween = create_tween()
	mod_tween.tween_property(self, "modulate", color, SPEED)
