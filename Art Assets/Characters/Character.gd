extends Node2D

@onready var anim_player: AnimationPlayer = get_node("%AnimationPlayer")

var idle:String = ""
var talking:String = ""
var is_talking:bool = false

var shake_effect: ShakeEffect

var fadetween: Tween
var movetween: Tween

signal animation_finished

# The number of animations we're waiting on to finish
var waiting_on_animations: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_to_group("characters")

	shake_effect = ShakeEffect.new()
	shake_effect.initialize(self.position, _on_shake)

	anim_player.animation_started.connect(_animation_started)
	anim_player.animation_finished.connect(_animation_finished)


func _animation_started(anim_name: StringName):
	if anim_player.get_animation(anim_name).loop_mode == Animation.LOOP_NONE:
		waiting_on_animations += 1


func _animation_finished():
	waiting_on_animations -= 1
	if waiting_on_animations <= 0:
		waiting_on_animations = 0
		animation_finished.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.position = shake_effect.get_shake_position()


func _on_shake(shake_amount:String):
	if shake_amount == "":
		shake_amount = "2.0"
	shake_effect.shake(self, shake_amount.to_float())


func set_animation(animation_name:String):
	idle = animation_name
	talking = ""

	# Only set the Idle/Talking animations if those are actually present
	# This allows us to play, say, an "Objection!" emote
	if anim_player.has_animation(animation_name + "_idle"):
		idle = animation_name + "_idle"
	if anim_player.has_animation(animation_name + "_talk"):
		talking = animation_name + "_talk"

	if(is_talking and talking):
		talk()
	else:
		no_talk()


func no_talk():
	is_talking = false
	if(idle != ""):
		anim_player.play(idle)


func talk():
	is_talking = true
	if(talking != ""):
		anim_player.play(talking)


func fade(out: bool = false, duration: float = 1.0):
	if fadetween:
		fadetween.kill()
	if duration <= 0:
		self_modulate.a = 0 if out else 1
		return
	fadetween = create_tween()
	fadetween.tween_property(self, "self_modulate:a", 0 if out else 1, duration)
	waiting_on_animations += 1
	await fadetween.finished
	_animation_finished()


func fadeout(duration: float = 1.0):
	self.self_modulate.a = 1.0
	fade(true, duration)


func fadein(duration: float = 1.0):
	self.self_modulate.a = 0.0
	fade(false, duration)


func flip_h(tog: bool = true, duration: float = 0.2):
	if tog and self.scale.x < 0:
		return
	if not tog and self.scale.x > 0:
		return
	self.scale.x = -self.scale.x


func shake():
	shake_effect.shake(self)


func move_to(target_pos: Vector2, target_scale: Vector2 = Vector2(1, 1), duration: float = 1.0, additive: bool = false):
	if movetween:
		movetween.custom_step(10000)
		movetween.kill()
	if additive:
		target_pos = position + target_pos
	if duration <= 0:
		position = target_pos
		shake_effect.default_position = target_pos
		scale = target_scale
		return
	movetween = create_tween()
	movetween.tween_property(self, "position", target_pos, duration).set_trans(Tween.TRANS_CUBIC)
	movetween.tween_property(shake_effect, "default_position", target_pos, duration).set_trans(Tween.TRANS_CUBIC)
	movetween.parallel().tween_property(self, "scale", target_scale, duration).set_trans(Tween.TRANS_CUBIC)
	waiting_on_animations += 1
	await movetween.finished
	_animation_finished()
