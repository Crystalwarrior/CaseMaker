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


func _on_TestScene_custom_signal(value):
	var args = value.split(';')
	if args[0] == 'anim':
		if len(args) >= 3 and args[2] == 'r':
			$AnimationPlayer.play_backwards(args[1])
		else:
			$AnimationPlayer.play(args[1])


func _on_Button_pressed():
	$AnimationPlayer.play("camera_def_to_pro")
