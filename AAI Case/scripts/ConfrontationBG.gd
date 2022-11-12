extends TextureRect

signal pan_finished()

# default offset positions for the AAI_Background texture rect
const DEF_POS = -32.0
const DEF_HELP_POS = 0.0
const RIVAL_POS = -544.0
const RIVAL_HELPER_POS = -576.0 

# positions in order of where the characters would show up on screen
const POSITIONS = [DEF_HELP_POS, DEF_POS, RIVAL_POS, RIVAL_HELPER_POS]

# speed for panning around the confrontation bg
const PANNING_SPD = 0.5
	
# starting_pos_index should come from ConfrontationPositions.gd
func initialize(texture_string:String, starting_pos_index:int):
	self.texture = load(texture_string)
	self.rect_position.x = POSITIONS[starting_pos_index]

# snap to/pan to confrontation bg positions
func snap_to_position(pos_index:int):
	self.rect_position.x = POSITIONS[pos_index]

# use this for objections, use the snap for everything else
func pan_to_position(pos_index:int, fast_pan:bool):
	var panning_speed = PANNING_SPD
	
	if(fast_pan):
		panning_speed = panning_speed / 2
		
	var panning_tween = create_tween()
	panning_tween.tween_property(self, "rect_position:x", POSITIONS[pos_index], panning_speed)
	panning_tween.tween_interval(0.5)
	yield(panning_tween, "finished")
	emit_signal("pan_finished")
