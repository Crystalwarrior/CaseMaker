@tool
extends Control

@onready var blip_player: AudioStreamPlayer = get_node("%BlipPlayer")
@onready var dialog_container: Control = get_node("%DialogContainer")
@onready var chat_arrow: TextureRect = dialog_container.get_node("%ChatArrow")
@onready var select_your_answer: TextureRect = get_node("%SelectYourAnswer")

var text_timer: Timer

signal text_shown()
signal unpause()

const PAUSE_AMT = 1.0
const BLIPMALE_STREAM: AudioStream = preload("res://assets/sounds/blips/male.wav")
const BLIPFEMALE_STREAM: AudioStream = preload("res://assets/sounds/blips/female.wav")
const BLIPTYPEWRITER_STREAM: AudioStream = preload("res://assets/sounds/blips/typewriter.wav")
const BLIPFOLDER = "res://assets/sounds/blips/"
# Text Speed constants
# 1 letter every 5 frames
const TEXT_SPEED_TYPEWRITER: float = 0.08
# 1 letter every 3 frames
const TEXT_SPEED_SLOW: float = 0.05
# 1 letter every 2 frames
const TEXT_SPEED_NORMAL: float = 0.034
# 1 letter every 1 frame
const TEXT_SPEED_FAST: float = 0.017
# 2 letters every 1 frame
const TEXT_SPEED_RAPID: float = 0.008

var current_spd:float = TEXT_SPEED_NORMAL
var speed_counter: float = 0.0
var process_dialog: bool = false

var pause:bool = false

var blip_rate: int = 2

var blip_counter: int = 0

var animation_tween: Tween

func set_speed(spd):
	current_spd = float(spd)
	if current_spd <= TEXT_SPEED_FAST:
		blip_rate = 3
	else:
		blip_rate = 2


func set_rapid():
	set_speed(TEXT_SPEED_RAPID)


func set_fast():
	set_speed(TEXT_SPEED_FAST)


func set_normal():
	set_speed(TEXT_SPEED_NORMAL)


func set_slow():
	set_speed(TEXT_SPEED_SLOW)


func set_typewriter():
	set_speed(TEXT_SPEED_TYPEWRITER)


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


func _process(delta):
	if(process_dialog):
		if(pause):
			return
		if dialog_container.text_displayed:
			text_finished()
			return
		speed_counter += delta
		if speed_counter < current_spd:
			return
		var count: int = int(speed_counter / current_spd)
		while (current_spd == 0 or count > 0) and process_dialog:
			count -= 1
			next_letter()
		# Lag compensation (in theory)
		speed_counter = speed_counter - current_spd


func next_letter():
	dialog_container.reveal_character()

	var current_char = dialog_container.get_current_character()
	if (!dialog_container.is_processing_command()):
		var skip_char = current_char in [" ", "\n"]
		if (not skip_char):
			if(blip_counter == 0 and not current_char.is_empty()):
				blip_player.play()
			blip_counter = (blip_counter + 1) % blip_rate


func set_blipsound(blip_string:String):
	var new_stream: AudioStream
	if blip_string == "male":
		new_stream = BLIPMALE_STREAM
	elif blip_string == "female":
		new_stream = BLIPFEMALE_STREAM
	elif blip_string == "typewriter":
		new_stream = BLIPTYPEWRITER_STREAM
	else:
		# Direct filepath to blip
		if ResourceLoader.exists(blip_string, "AudioStream"):
			new_stream = load(blip_string)
		# Filename in the blips folder
		elif ResourceLoader.exists(BLIPFOLDER + blip_string + ".wav", "AudioStream"):
			new_stream = load(BLIPFOLDER + blip_string + ".wav")
		else:
			push_error("Blip sound ", blip_string, " not found!")
	blip_player.set_stream(new_stream)


func display_text(text:String, showname:String = "", additive:bool = false):
	if additive:
		dialog_container.add_text_to_show(text)
	else:
		dialog_container.set_text_to_show(text)
	dialog_container.set_showname_text(showname)
	blip_counter = 0
	speed_counter = 0
	process_dialog = true


func text_finished():
	process_dialog = false
	set_normal()
	text_shown.emit()


func select_answer_graphic(toggle: bool = true):
	if animation_tween:
		animation_tween.custom_step(9999)
		animation_tween.kill()
	if toggle and select_your_answer.visible:
		return
	select_your_answer.set_visible(toggle)
	if toggle:
		animation_tween = create_tween()
		animation_tween.tween_property(dialog_container, "position:y", \
			dialog_container.position.y-select_your_answer.size.y, 0.4)
		animation_tween.parallel().tween_property(select_your_answer, "position:y", \
			select_your_answer.position.y-select_your_answer.size.y, 0.4)
	else:
		dialog_container.position.y += select_your_answer.size.y
		select_your_answer.position.y += select_your_answer.size.y


func _on_pause_called(pause_string:String):
	pause = true
	if pause_string == "":
		pause_string = "0.2"
	text_timer = Timer.new()
	text_timer.wait_time = PAUSE_AMT * pause_string.to_float()
	text_timer.autostart = true
	add_child(text_timer)
	await text_timer.timeout
	pause = false
	unpause.emit()
	text_timer.queue_free()
