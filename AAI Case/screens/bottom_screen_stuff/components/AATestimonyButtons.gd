extends Control

signal press()
signal present()

signal left_button_press()
signal right_button_press()

func _on_LeftButton_pressed():
	emit_signal("left_button_press")

func _on_RightButton_pressed():
	emit_signal("right_button_press")

func _on_PressBtn_pressed():
	emit_signal("press")

func _on_PresentBtn_pressed():
	emit_signal("present")
