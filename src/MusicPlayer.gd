extends AudioStreamPlayer


onready var tween = $Tween


func play_music(song):
	volume_db = 0.0
	stream = song
	play()


func stop_music(fade_duration=0):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", -80.0, fade_duration)
	tween.tween_callback(self, "stop")
