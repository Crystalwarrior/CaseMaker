extends Node
class_name ShakeEffect

var shake_amount: float = 0
var default_position: Vector2
var shake_timer: float = 0
const SHAKE_TIME = 0.3

# Processing only happens if we are parented to a node
func _process(delta):
	if shake_amount <= 0 or shake_timer <= 0:
		shake_amount = 0
		shake_timer = 0
		get_parent().remove_child(self)
		return
	shake_timer -= delta

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

func shake(node:Node, amount:float = 2.0, shake_time:float = SHAKE_TIME):
	# We must be parented to something so we can process the timer
	if get_parent() != node:
		node.add_child(self)
	shake_amount = amount
	shake_timer = shake_time
