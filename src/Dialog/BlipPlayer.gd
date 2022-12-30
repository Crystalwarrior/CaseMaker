extends AudioStreamPlayer

# path to the blip sound we want
var blip_sound setget set_blip_sound

func _ready():
	self.volume_db = 0.5

func set_blip_sound(blip_sound_path):
	self.set_stream(blip_sound_path)

func _play_blip():
	self.play()
		
