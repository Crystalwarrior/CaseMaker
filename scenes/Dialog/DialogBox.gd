extends Control

@onready var blip_player: AudioStreamPlayer = get_node("%BlipPlayer")
@onready var text_timer: Timer = get_node("%TimerNode")
@onready var dialog_container: Control = get_node("%DialogContainer")

signal text_shown()
signal unpause()

const PAUSE_AMT = 0.2

var blip:bool = false
var pause:bool = false


func adv():
	dialog_container.size = Vector2(256, 57)
	dialog_container.position = Vector2(0, 135)

func nov():
	dialog_container.size = Vector2(256, 182)
	dialog_container.position = Vector2(0, 10)

func _ready():
	var cmd_value_instance = CommandValues.instance()
	cmd_value_instance.eff_pause.connect(_on_pause_called)
	
	cmd_value_instance.spd_fast.connect(text_timer.set_fast)
	cmd_value_instance.spd_normal.connect(text_timer.set_normal)
	cmd_value_instance.spd_slow.connect(text_timer.set_slow)
	cmd_value_instance.spd_typewriter.connect(text_timer.set_typewriter)
	
	cmd_value_instance.adv_mode.connect(adv)
	cmd_value_instance.nov_mode.connect(nov)

func display_text(text:String, showname:String = "", is_male:bool = true):
	dialog_container.set_text_to_show(text)
	dialog_container.set_showname_text(showname)
	blip_player.set_blip_sound(is_male)
	
	while(!dialog_container.text_displayed):
		blip = !blip
		var current_char = dialog_container.get_current_character()
		
		if(pause):
			await unpause
			
		if (current_char != " " or current_char == "\n"):
			if(blip and !dialog_container.is_processing_command()):
				blip_player.play()
		else:
			blip = false
			
		dialog_container.reveal_character()
		text_timer.start_timer()
		await text_timer.timed_out
	
	text_timer.set_normal()
	text_shown.emit()

func _on_pause_called(pause_string:String):
	pause = true
	text_timer.start(PAUSE_AMT * pause_string.to_int())
	await text_timer.timeout
	pause = false
	unpause.emit()
