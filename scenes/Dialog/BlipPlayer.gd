extends AudioStreamPlayer

@onready var blipmale_stream: AudioStream = preload("res://scenes/Dialog/blipmale.wav")
@onready var blipfemale_stream: AudioStream = preload("res://scenes/Dialog/blipfemale.wav")
@onready var current_stream: AudioStream = null

func set_blip_sound(is_male:bool):
	var new_stream: AudioStream = null
	
	if(is_male):
		new_stream = blipmale_stream
	else:
		new_stream = blipfemale_stream
	
	if(current_stream != null and current_stream != new_stream):
		current_stream = new_stream
		self.set_stream(current_stream)
