extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween()
	var duration = 0.1
	tween.tween_property(self, "modulate:a", 0, duration).set_ease(Tween.EASE_OUT)
	tween.tween_callback(self.queue_free)
