extends Button

@onready var dink_player = $AudioStreamPlayer
@onready var panel = $Panel

var panel_normal = preload("res://assets/ui/themes/stylebox/aa/aa_button2_normal.tres")
var panel_pressed = preload("res://assets/ui/themes/stylebox/aa/aa_button2_pressed.tres")

var animation_tween: Tween

var pressed_down = false

func _ready():
	button_down.connect(_button_down)
	button_up.connect(_button_up)


func _button_down():
	pressed_down = true
	dink_player.play()
	play_animation()


func _button_up():
	pressed_down = false


func _animation_finished():
	interrupt_animation()


func disable(toggle: bool = true):
	disabled = toggle


func interrupt_animation():
	if animation_tween:
		animation_tween.custom_step(9999)
		animation_tween.kill()
	panel.scale = Vector2(1, 1)
	panel.add_theme_stylebox_override("panel", panel_normal)


func play_animation():
	interrupt_animation()
	panel.add_theme_stylebox_override("panel", panel_pressed)
	animation_tween = create_tween()
	animation_tween.tween_property(panel, "scale", Vector2(0.9, 0.9), 0.05)
	animation_tween.finished.connect(_animation_finished)
