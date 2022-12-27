extends TextureRect

signal anim_finished()

func hold_it():
	play_animation("holdit")

func objection():
	play_animation("objection")

func take_that():
	play_animation("takethat")

func play_animation(animation):
	self.visible = true
	$AnimationPlayer.play(animation)

func _on_AnimationPlayer_animation_finished(anim_name):
	self.visible = false
	emit_signal("anim_finished")
