extends TextureRect

# default offset positions for the AAI_Background texture rect
const DEF_POS = 0.0
const RIVAL_POS = -512.0
const SPEED = 0.15

# positions in order of where the characters would show up on screen
const POSITIONS = [DEF_POS, RIVAL_POS]

# speed for panning around the confrontation bg
const PANNING_SPD = 0.5

func fade_to_grey():
	var fade_out_tween = create_tween()
	fade_out_tween.tween_property(self, "self_modulate", Color8(111,111,111), SPEED)

func fade_to_normal():
	var fade_in_tween = create_tween()
	fade_in_tween.tween_property(self, "self_modulate", Color8(255,255,255), SPEED)
