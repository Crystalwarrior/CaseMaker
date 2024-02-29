extends Node2D

var shake_effect: ShakeEffect
var fadetween: Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	shake_effect = ShakeEffect.new()
	shake_effect.initialize(position, _on_shake)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.position = shake_effect.get_shake_position()

func _on_shake(shake_amount:String):
	if shake_amount == "":
		shake_amount = "2.0"
	shake_effect.shake(self, shake_amount.to_float())


func change_to(background):
	var bg = null

	if background is PackedScene:
		bg = background.instantiate()
	if background is Texture2D:
		bg = Sprite2D.new()
		bg.centered = false
		bg.texture = background

	if bg == null:
		push_error("[Change Background] Background Object '", background, "' not valid! Must be a Texture2D or a PackedScene.")
		return

	get_child(0).queue_free()
	add_child(bg)


func fade(to_color: Color = Color(0, 0, 0, 0), duration: float = 1.0):
	if fadetween:
		fadetween.kill()
	if duration <= 0:
		modulate = to_color
	else:
		fadetween = create_tween()
		fadetween.tween_property(self, "modulate", to_color, duration)


func fadeout(duration: float = 1.0):
	fade(Color.BLACK, duration)


func fadein(duration: float = 1.0):
	fade(Color(0, 0, 0, 0), duration)
