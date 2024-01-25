extends Node2D

@onready var anim_player = get_node("%AnimationPlayer")

var idle:String = ""
var talking:String = ""
var is_talking:bool = false

func set_animation(animation_name:String):
	if(animation_name != ""):
		idle = animation_name + "_idle"
		talking = animation_name + "_talk"
		
		if(is_talking):
			talk()
		else:
			no_talk()

func no_talk():
	if(idle != ""):
		anim_player.play(idle)
		is_talking = false
		
func talk():
	if(talking != ""):
		anim_player.play(talking)
		is_talking = true


