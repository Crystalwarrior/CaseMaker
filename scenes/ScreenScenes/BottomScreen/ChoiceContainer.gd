extends ScrollContainer

@onready var box_container = $VBoxContainer
@onready var audio_player = $AudioStreamPlayer

var choice_scene: PackedScene = preload("res://scenes/ScreenScenes/BottomScreen/choice_button.tscn")

var audio_focused: AudioStream = preload("res://assets/sounds/ui/selectblip.wav")
var audio_pressed: AudioStream = preload("res://assets/sounds/ui/selectblip2.wav")

signal choice_selected(index)

func clear_choices():
	for child in box_container.get_children():
		child.queue_free()


func add_choice(choice: String):
	var added_choice = choice_scene.instantiate()
	added_choice.text = choice
	box_container.add_child(added_choice)
	added_choice.pressed.connect(_choice_pressed.bind(added_choice))
	added_choice.focus_entered.connect(_choice_focused.bind(added_choice))
	return added_choice


func populate_choices(choices: PackedStringArray):
	clear_choices()
	for choice in choices:
		add_choice(choice)


func _choice_pressed(choice: Button):
	ensure_control_visible(choice)
	audio_player.set_stream(audio_pressed)
	audio_player.play()
	choice_selected.emit(choice.get_index())


func _choice_focused(choice: Button):
	ensure_control_visible(choice)
	audio_player.set_stream(audio_focused)
	audio_player.play()
