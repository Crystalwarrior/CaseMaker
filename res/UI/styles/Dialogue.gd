extends PanelContainer

export var text_delay = 0.02 #20ms per symbol

export(Array, AudioStreamSample) var blip_sounds
export(Array, AudioStreamSample) var space_sounds

#Where the actual text is displayed.
onready var text = $Text
onready var blip = $BlipSound

#The text we're currently parsing stripped of newline chars
var parsing_text = ""
#Current character we're parsing
var character = ""

var timer = 0
var wait_time = 0
var running = false
var paused = false

signal finished

func set_text(msg):
	text.text = msg

func set_text_delay(delay):
	wait_time = delay

func start():
	set_paused(false)
	running = true

func set_paused(toggle=null):
	if toggle == null:
		toggle = not paused
	paused = toggle

func stop():
	running = false

func finished():
	stop()
	emit_signal("finished")

func is_active():
	return running

func display_text(msg="", delay=null):
	if msg != "":
		set_text(msg)
	if delay != null:
		set_text_delay(delay)
	else:
		set_text_delay(text_delay)
	#Strip out new lines as they're invisible to visible_characters
	parsing_text = text.text.replace("\n", "")
	text.set_visible_characters(0)
	start()

func _process(delta):
	if not running or paused:
		return
	if text.visible_characters == -1 or text.visible_characters >= parsing_text.length():
		finished()
		return
	timer += delta
	if timer >= wait_time:
		character = parsing_text[text.visible_characters]
		parse_character(character)
		text.visible_characters += 1
		update()
		blip.play()
		timer = 0

func _draw():
	draw_rect(
		Rect2(
			Vector2(
				7 + text.get_font("normal_font").get_string_size(parsing_text.substr(0, text.visible_characters-1)).x,
				7
			),
			text.get_font("normal_font").get_string_size(character)
		),
		Color.white,
		false
	)

func parse_character(character):
	#Increase the delay due to "pausing" to take your breath.
	if character in ".,!?:;-":
		set_text_delay(text_delay * 4)
	else:
		set_text_delay(text_delay)

	randomize()
	if character in " " and not space_sounds.empty():
		blip.set_stream(space_sounds[randi() % space_sounds.size()])
	elif not blip_sounds.empty():
		blip.set_stream(blip_sounds[randi() % blip_sounds.size()])
