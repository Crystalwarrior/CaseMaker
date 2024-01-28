extends ColorRect

var fadetween: Tween

func fade(to_color: Color = Color(0, 0, 0, 0), duration: float = 1.0):
	if fadetween:
		fadetween.kill()
	if duration <= 0:
		color = to_color
	else:
		fadetween = create_tween()
		fadetween.tween_property(self, "color", to_color, duration)


func fadeout(duration: float = 1.0):
	fade(Color.BLACK, duration)


func fadein(duration: float = 1.0):
	fade(Color(0, 0, 0, 0), duration)
