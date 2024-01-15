extends Control

@onready var blip_player: AudioStreamPlayer = get_node("%BlipPlayer")
@onready var text_timer: Timer = get_node("%TimerNode")
@onready var dialog_container: Control = get_node("%DialogContainer")

signal text_shown()
signal unpause()

const PAUSE_AMT = 1.0
const BLIPMALE_STREAM: AudioStream = preload("res://assets/sounds/blipmale.wav")
const BLIPFEMALE_STREAM: AudioStream = preload("res://assets/sounds/blipfemale.wav")
const BLIPTYPEWRITER_STREAM: AudioStream = preload("res://assets/sounds/typewriter.wav")
const BLIPSANS_STREAM: AudioStream = preload("res://assets/sounds/sans.wav")


var pause:bool = false

var blip_rate: int = 2

var blip_counter: int = 0


func set_speed(spd:float):
	text_timer.current_spd = spd


func set_fast():
	blip_rate = 3
	text_timer.set_fast()


func set_normal():
	blip_rate = 2
	text_timer.set_normal()


func set_slow():
	blip_rate = 2
	text_timer.set_slow()


func set_typewriter():
	blip_rate = 2
	text_timer.set_typewriter()


func adv():
	dialog_container.size = Vector2(256, 57)
	dialog_container.position = Vector2(0, 135)


func nov():
	dialog_container.size = Vector2(256, 182)
	dialog_container.position = Vector2(0, 10)


func _ready():
	var cmd_value_instance = CommandValues.instance()
	cmd_value_instance.eff_pause.connect(_on_pause_called)
	
	cmd_value_instance.spd.connect(set_speed)
	cmd_value_instance.spd_fast.connect(set_fast)
	cmd_value_instance.spd_normal.connect(set_normal)
	cmd_value_instance.spd_slow.connect(set_slow)
	cmd_value_instance.spd_typewriter.connect(set_typewriter)
	
	cmd_value_instance.adv_mode.connect(adv)
	cmd_value_instance.nov_mode.connect(nov)
	
	cmd_value_instance.blip.connect(set_blipsound)


func set_blipsound(blip_string:String):
	print(blip_string)
	var new_stream: AudioStream
	if blip_string == "male":
		new_stream = BLIPMALE_STREAM
	elif blip_string == "female":
		new_stream = BLIPFEMALE_STREAM
	elif blip_string == "typewriter":
		new_stream = BLIPTYPEWRITER_STREAM
	elif blip_string == "sans":
		new_stream = BLIPSANS_STREAM
	else:
		new_stream = load(blip_string)
	blip_player.set_stream(new_stream)


func display_text(text:String, showname:String = ""):
	dialog_container.set_text_to_show(text)
	dialog_container.set_showname_text(showname)
	blip_counter = 1
	%DEBUG.clear()
	%DEBUG.text = ""
	while(!dialog_container.text_displayed):
		var current_char = dialog_container.get_current_character()
		
		if(pause):
			await unpause
		var blip = false
		if (!dialog_container.is_processing_command()):
			var skip_char = current_char in [" ", "\n"]
			if (not skip_char):
				if(blip_counter == 0):
					blip = true
					blip_player.play()
				blip_counter = (blip_counter + 1) % blip_rate
		if blip:
			%DEBUG.push_color(Color.GREEN)
		%DEBUG.add_text(current_char)
		if blip:
			%DEBUG.pop()
		dialog_container.reveal_character()
		text_timer.start_timer()
		await text_timer.timed_out
	
	set_normal()
	text_shown.emit()

func _on_pause_called(pause_string:String):
	pause = true
	text_timer.start(PAUSE_AMT * pause_string.to_float())
	await text_timer.timeout
	pause = false
	unpause.emit()
