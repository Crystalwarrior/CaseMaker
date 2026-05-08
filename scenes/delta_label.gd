extends Label


func _process(delta):
	if not visible:
		return
	text = str(snapped(delta, 0.000001)*1000) + "ms"
