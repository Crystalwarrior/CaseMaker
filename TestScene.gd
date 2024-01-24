extends Node2D
@onready var next_button = get_node("%NextButton")
@onready var chat_arrow = get_node("%ChatArrow")
@onready var big_arrow = get_node("%BigArrow")
@onready var flash = preload("res://scenes/ScreenScenes/UpperScreen/Effects/FlashEffect.tscn")

@onready var upper_screen = get_node("%UpperScreen")

@onready var command_processor: CommandProcessor = get_node("%CommandProcessor")

var finished: bool = false
var waiting_on_input: bool = true

var scene_manager: SceneManager
var dialog_box

signal dialog_finished

func _ready():
	CommandValues.instance().eff_flash.connect(_on_flash)
	scene_manager = upper_screen.create_scene_manager()
	dialog_box = scene_manager.get_dialog_box()
	dialog_box.text_shown.connect(_on_text_shown)


func next():
	get_window().gui_release_focus()
	# TODO: implement skipping
	if not finished:
		if not command_processor.main_collection:
			command_processor.start()
		else:
			command_processor.go_to_next_command()


func create_scene_command(nametag, animation, text, showname, wait_for_input = true) -> SceneCommand:
	var command = SceneCommand.new()
	
	command.character_name = nametag	
	command.character_animation = animation
	command.text_for_scene = text
	command.showname_for_scene = showname
	command.wait_for_input = wait_for_input
	
	return command


func set_waiting_on_input(tog: bool):
	waiting_on_input = tog

	next_button.disabled = not waiting_on_input
	chat_arrow.visible = waiting_on_input
	big_arrow.visible = waiting_on_input


func dialog(showname: String = "", text: String = "", additive: bool = false, letter_delay: float = 0.03) -> void:
	dialog_box.current_spd = letter_delay
	dialog_box.display_text(text, showname)
	#TODO: implement additive text boxes


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


func _on_next_button_pressed():
	next()


func _on_text_shown():
	dialog_finished.emit()
