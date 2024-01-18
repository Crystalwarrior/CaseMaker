@tool
extends Control

@onready var dialog_box: Control = %DialogBox
@onready var showname_box: Control = %ShownameBox
@onready var text_label: RichTextLabel = %DialogTextLabel
@onready var showname_margin: Control = %ShownameMargin
@onready var showname_label: RichTextLabel = %ShownameText
var command_processor:CommandProcessor
var text_displayed: bool = false
var shake_effect: ShakeEffect

signal is_text_displayed()

var _old_text = ""

func _init():
	if Engine.is_editor_hint():
		return
	command_processor = CommandProcessor.new()

func _process(_delta):
	# Showname stuff
	showname_box.global_position = showname_margin.global_position
	var showname_offset := Vector2(0, -10)
	showname_margin.global_position = self.global_position + showname_offset
	if shake_effect:
		showname_margin.global_position += shake_effect.get_shake_amount()
	showname_box.set_visible(showname_label.text != "")
	if _old_text != text_label.text:
		showname_margin.size = Vector2(0, 0)
		_old_text = text_label.text

	# Dialog stuff
	dialog_box.global_position = self.global_position
	if shake_effect:
		dialog_box.global_position += shake_effect.get_shake_amount()

func _ready():
	resized.connect(_on_resized)
	showname_margin.resized.connect(_on_showname_resized)
	if Engine.is_editor_hint():
		return
	shake_effect = ShakeEffect.new()
	shake_effect.initialize(position, _on_shake)

func _on_shake():
	shake_effect.shake(self)

func _on_resized():
	if not dialog_box:
		return
	dialog_box.size = self.size

func _on_showname_resized():
	showname_box.size.x = showname_margin.size.x

func _on_text_edited():
	self.size = Vector2(0, 0)

func set_showname_text(showname_text:String):
	showname_label.text = showname_text

func set_text_to_show(text_to_show:String):
	if Engine.is_editor_hint():
		return
	if not text_label:
		return
	
	for character in text_to_show:
		command_processor.add_command_char(character)
	
	text_to_show = command_processor.remove_commands_from_string(text_to_show)
	text_label.set_text(text_to_show)
	text_label.visible_characters = 0
	text_displayed = false

func reveal_character():
	if Engine.is_editor_hint():
		return
	text_label.visible_characters += 1
	var index = text_label.visible_characters
	
	if(index == text_label.get_parsed_text().length()):
		text_displayed = true
		is_text_displayed.emit()
		command_processor.end_command_processing()
	else:
		command_processor.process_command(index-1)

func get_current_character() -> String:
	return text_label.get_parsed_text()[text_label.visible_characters-1]

func is_processing_command() -> bool:
	return command_processor.is_processing
