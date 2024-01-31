extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.2).set_ease(Tween.EASE_OUT)
	tween.tween_callback(self.queue_free)
