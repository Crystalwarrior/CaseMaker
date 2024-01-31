@tool
extends TextureRect

var shake_effect: ShakeEffect
	
# Called when the node enters the scene tree for the first time.
func _ready():
	shake_effect = ShakeEffect.new()
	shake_effect.initialize(position, _on_shake)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = shake_effect.get_shake_position()

func _on_shake():
	shake_effect.shake(self)
