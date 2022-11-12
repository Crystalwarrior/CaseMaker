extends Node2D

onready var animation_player = $AnimationPlayer
onready var character_sprite = $Sprite

# the character's showname
var nametag

# constants
const FADE_IN_OUT_SPD = 0.25
const FADE_IN = 255
const FADE_OUT = 0


# -- Sprite Effects --

# reset our character to its most neutral state
# this is needed because we are using persistant instances
func reset_character_properties():
	fade_in()
	self.position.x = 0
	make_character_idle("normal")

# change character opacity
func fade_in():
	fade_in_out(FADE_IN)

func fade_out():
	fade_in_out(FADE_OUT)

func fade_in_out(fade_value:float):
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", fade_value, FADE_IN_OUT_SPD)


# -- Animations -- 

# all idle emotes have an (a) in front of them
func make_character_idle(animation_name):
	var idle_animation = "(a)" + animation_name
	play_animation(idle_animation)

# all talking emotes have a (b) in front of them
func make_character_talk(animation_name):
	var talk_animation = "(b)" + animation_name
	play_animation(talk_animation)

func play_animation(animation_name:String):
	animation_player.play(animation_name)