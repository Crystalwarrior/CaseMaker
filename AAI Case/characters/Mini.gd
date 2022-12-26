extends Sprite

const FADE_IN = 255
const FADE_OUT = 0

var char_name

func _ready():
	self.centered = false

# change character opacity
func fade_in():
	fade_in_out(FADE_IN)

func fade_out():
	fade_in_out(FADE_OUT)

func fade_in_out(fade_value:float):
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", fade_value, 0.15)
