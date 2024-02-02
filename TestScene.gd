extends Control
@onready var bottom_screen = get_node("%BottomScreen")
@onready var next_button = bottom_screen.next_button
@onready var choice_container = bottom_screen.choice_container
@onready var flash = preload("res://scenes/ScreenScenes/UpperScreen/Effects/FlashEffect.tscn")

@onready var upper_screen = get_node("%UpperScreen")

@onready var command_processor: CommandProcessor = get_node("%CommandProcessor")

var finished: bool = false
var waiting_on_input: bool = true

var scene_manager: SceneManager
var dialog_box

signal dialog_finished
signal choice_selected(index)

func _ready():
	CommandValues.instance().eff_flash.connect(_on_flash)
	scene_manager = upper_screen.create_scene_manager()
	dialog_box = scene_manager.get_dialog_box()
	dialog_box.text_shown.connect(_on_text_shown)
	
	next_button.connect("button_down", _on_next_button_down)
	bottom_screen.choice_selected.connect(_on_choice_selected)


func next():
	#get_window().gui_release_focus()
	# TODO: implement skipping
	if not finished:
		if not command_processor.main_collection:
			command_processor.start()
		else:
			command_processor.go_to_next_command()


func set_waiting_on_input(tog: bool):
	waiting_on_input = tog
	next_button.disable(not waiting_on_input)
	upper_screen.set_chat_arrow_visible(waiting_on_input)


func dialog(dialog_command:Command) -> void:
	var showname = dialog_command.showname
	var dialog = dialog_command.dialog
	var additive = dialog_command.additive
	var letter_delay = dialog_command.letter_delay
	var blip_sound = dialog_command.blip_sound
	var wait_until_finished = dialog_command.wait_until_finished
	var speaking_character = dialog_command.speaking_character
	var bump_speaker = dialog_command.bump_speaker
	var highlight_speaker = dialog_command.highlight_speaker
	var hide_dialog = dialog_command.hide_dialog
	dialog_box.current_spd = letter_delay
	dialog_box.display_text(dialog, showname)
	if blip_sound:
		dialog_box.set_blipsound(blip_sound)
	#TODO: implement additive text boxes


func set_dialog_visible(toggle: bool = true):
	dialog_box.set_visible(toggle)


func multiple_choice(choices: PackedStringArray):
	upper_screen.select_your_answer(true)
	await get_tree().create_timer(0.4).timeout
	bottom_screen.multiple_choice(choices)


func _on_flash():
	upper_screen.add_child(flash.instantiate())


func _on_command_processor_collection_started(collection):
	finished = false


func _on_command_processor_collection_finished(collection):
	finished = true


func _on_command_processor_command_started(command):
	set_waiting_on_input(false)


func _on_command_processor_command_finished(command):
	var command_is_dialog = command.get_script().resource_path == "res://addons/textalog/commands/command_dialog.gd"
	set_waiting_on_input(command_is_dialog)


func _on_text_shown():
	dialog_finished.emit()


func _on_next_button_down():
	next()


func _on_choice_selected(index):
	upper_screen.select_your_answer(false)
	choice_selected.emit(index)
