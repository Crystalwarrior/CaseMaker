extends AudioStreamPlayer


var fadetween: Tween


func play_track(new_stream: AudioStream, target_db: float = 0.0, duration: float = 1.0):
	stream = new_stream
	stream_paused = false
	if new_stream == null:
		stop_track(duration)
		return
	fade(target_db, duration)
	play()


func stop_track(duration: float = 1.0):
	fade(-80.0, duration)
	if duration > 0:
		await fadetween.finished
	stream_paused = true


func unpause_track(target_db: float = 0.0, duration: float = 1.0):
	fade(target_db, duration)
	if duration > 0:
		await fadetween.finished
	stream_paused = false


func fade(target_db = 0.0, duration: float = 1.0):
	if fadetween:
		fadetween.kill()
	if duration <= 0:
		volume_db = target_db
		stream_paused = target_db <= -80.0
		return
	fadetween = create_tween()
	fadetween.tween_property(self, "volume_db", target_db, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN if target_db <= volume_db else Tween.EASE_OUT)
	stream_paused = false
