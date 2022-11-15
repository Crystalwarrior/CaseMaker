extends TextureRect

signal pan_finished()

# default offset positions for the AAI_Background texture rect
const DEF_POS = 0.0
const RIVAL_POS = -512.0

# positions in order of where the characters would show up on screen
const POSITIONS = [DEF_POS, RIVAL_POS]

# speed for panning around the confrontation bg
const PANNING_SPD = 0.5

# snap to/pan to confrontation bg positions
func snap_to_position(pos_index:int):
	self.rect_position.x = POSITIONS[pos_index]

# use this for objections, use the snap for everything else
func pan_to_position(pos_index:int):
	var panning_tween = create_tween()
	panning_tween.tween_property(self, "rect_position:x", POSITIONS[pos_index], PANNING_SPD)
