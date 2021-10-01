extends Node2D

func _on_ColorPicker_color_changed(color):
	$fx.color = color


func _on_Next_pressed():
	var a = InputEventAction.new()
	a.action = "ui_accept"
	a.pressed = true
	Input.parse_input_event(a)
	yield(get_tree(),"idle_frame")
	a.pressed = false
	Input.parse_input_event(a)


func _on_Color_pressed():
	$HUD/ColorPicker.visible = not $HUD/ColorPicker.visible
