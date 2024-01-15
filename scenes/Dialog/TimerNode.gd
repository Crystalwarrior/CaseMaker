extends Node

signal timed_out()

const TYPEWRITER = 0.08
const SLOW = 0.06
const NORMAL = 0.03
const FAST = 0.015

var current_spd:float = NORMAL
var elapsed_time:float = 0
var active:bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(active):
		elapsed_time += delta
		if(elapsed_time >= current_spd):
			elapsed_time = 0
			active = false
			timed_out.emit()

func start_timer():
	active = true

func set_typewriter():
	current_spd = TYPEWRITER

func set_slow():
	current_spd = SLOW

func set_normal():
	current_spd = NORMAL

func set_fast():
	current_spd = FAST

func _on_timeout():
	timed_out.emit()
