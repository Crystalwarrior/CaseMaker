extends Button

@onready var dink_player = $AudioStreamPlayer

func _pressed():
	scale = Vector2(0.9, 0.9)
	dink_player.play()
	await get_tree().create_timer(0.05).timeout
	scale = Vector2(1, 1)
