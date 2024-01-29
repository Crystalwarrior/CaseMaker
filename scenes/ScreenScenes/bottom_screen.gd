extends Control

@onready var next_button = %NextButton
@onready var animation_player = $AnimationPlayer

func _on_court_record_button_pressed():
	animation_player.play("court_record_pressed")
