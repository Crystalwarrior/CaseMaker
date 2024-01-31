@tool
class_name ShakeEffect

var shake_amount: float = 0
var default_position: Vector2
var shake_timer:Timer
const SHAKE_TIME = 0.3

func initialize(position:Vector2, shake_callback):
	default_position = Vector2(position)
	CommandValues.instance().eff_shake.connect(shake_callback)

func set_default_position(position:Vector2):
	default_position = Vector2(position)

func get_shake_amount() -> Vector2:
	return Vector2(randf_range(-shake_amount, shake_amount), 
					randf_range(-shake_amount, shake_amount))

func get_shake_position() -> Vector2:
	return default_position + get_shake_amount()

func shake(node:Node):
	shake_amount = 2
	await node.get_tree().create_timer(SHAKE_TIME).timeout
	shake_amount = 0
