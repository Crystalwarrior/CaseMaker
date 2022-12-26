extends Control

var main_button
var testimony_buttons

# Called when the node enters the scene tree for the first time.
func _ready():
	main_button = $AAButton
	testimony_buttons = $TestimonyButtons

func set_main_button_visible():
	main_button.visible = true
	testimony_buttons.visible = false

func set_testimony_buttons_visible():
	testimony_buttons.visible = true
	main_button.visible = false
