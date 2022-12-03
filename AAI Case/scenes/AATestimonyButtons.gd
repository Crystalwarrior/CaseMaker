extends "res://AAI Case/scenes/AAButton.gd"

signal show_press_dialog()
signal show_present_menu()

signal left_button_press()
signal right_button_press()

func _on_LeftButton_pressed():
	emit_signal("left_button_press")

func _on_RightButton_pressed():
	emit_signal("right_button_press")

func _on_PressBtn_pressed():
	emit_signal("show_press_dialog")

func _on_PresentBtn_pressed():
	emit_signal("show_present_menu")
