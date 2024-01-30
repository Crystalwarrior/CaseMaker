extends Control

@onready var blip_player: AudioStreamPlayer = get_node("%BlipPlayer")
@onready var text_timer: Timer = get_node("%TimerNode")
@onready var dialog_container: Control = get_node("%DialogContainer")
@onready var chat_arrow: TextureRect = dialog_container.get_node("%ChatArrow")
@onready var select_your_answer: TextureRect = get_node("%SelectYourAnswer")

signal text_shown()
signal unpause()

const PAUSE_AMT = 1.0
const BLIPMALE_STREAM: AudioStream = preload("res://assets/sounds/blips/male.wav")
const BLIPFEMALE_STREAM: AudioStream = preload("res://assets/sounds/blips/female.wav")
const BLIPTYPEWRITER_STREAM: AudioStream = preload("res://assets/sounds/blips/typewriter.wav")
const BLIPSANS_STREAM: AudioStream = preload("res://assets/sounds/blips/sans.wav")

# Text Speed constants
# 1 letter every 5 frames
const TEXT_SPEED_TYPEWRITER: float = 0.08
# 1 letter every 3 frames
const TEXT_SPEED_SLOW: float = 0.05
# 1 letter every 2 frames
const TEXT_SPEED_NORMAL: float = 0.03
# 1 letter every 1 frame
const TEXT_SPEED_FAST: float = 0.015
# 2 letters every 1 frame
const TEXT_SPEED_RAPID: float = 0.008

var current_spd:float = TEXT_SPEED_NORMAL
var speed_counter: float = 0.0
var process_dialog: bool = false

var pause:bool = false

var blip_rate: int = 2

var blip_counter: int = 0

var animation_tween: Tween

func set_speed(spd:String):
	current_spd = spd.to_float()


func set_rapid():
	blip_rate = 4
	current_spd = TEXT_SPEED_RAPID


func set_fast():
	blip_rate = 3
	current_spd = TEXT_SPEED_FAST


func set_normal():
	blip_rate = 2
	current_spd = TEXT_SPEED_NORMAL


func set_slow():
	blip_rate = 2
	current_spd = TEXT_SPEED_SLOW


func set_typewriter():
	blip_rate = 2
	current_spd = TEXT_SPEED_TYPEWRITER


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
	if(process_dialog and not dialog_container.text_displayed):
		if(pause):
			return
		speed_counter += delta
		if speed_counter < current_spd:
			return
		var count: int = int(speed_counter / current_spd)
		while (current_spd == 0 or count > 0) and process_dialog:
			count -= 1
			next_letter()
		speed_counter = 0


func next_letter():
	dialog_container.reveal_character()

	var current_char = dialog_container.get_current_character()
	var blip = false
	if (!dialog_container.is_processing_command()):
		var skip_char = current_char in [" ", "\n"]
		if (not skip_char):
			if(blip_counter == 0 and not current_char.is_empty()):
				blip = true
				blip_player.play()
			blip_counter = (blip_counter + 1) % blip_rate
	if blip:
		%DEBUG.push_color(Color.GREEN)
	%DEBUG.add_text(current_char)
	if blip:
		%DEBUG.pop()


func set_blipsound(blip_string:String):
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
	blip_counter = 0
	%DEBUG.clear()
	%DEBUG.text = ""
	speed_counter = 0
	process_dialog = true
	await dialog_container.is_text_displayed
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
	text_timer.start(PAUSE_AMT * pause_string.to_float())
	await text_timer.timeout
	pause = false
	unpause.emit()
