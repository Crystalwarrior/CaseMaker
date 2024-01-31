@tool
extends Control

# showname_box and dialog_box are the visual panels behind the text.
# They're parented to CanvasGroup becuase of transparency merging issues.
@onready var dialog_box: Control = %DialogBox
@onready var showname_box: Control = %ShownameBox

@onready var text_label: RichTextLabel = %DialogTextLabel
@onready var showname_margin: Control = %ShownameMargin
@onready var showname_label: Label = %ShownameText
@onready var chat_arrow: TextureRect = %ChatArrow
var command_processor:TextCommandProcessor
var text_displayed: bool = false
var shake_effect: ShakeEffect

signal is_text_displayed()

var _old_text = ""

func _init():
	command_processor = TextCommandProcessor.new()

func _process(_delta):
	if _old_text != text_label.text:
		showname_margin.size = Vector2(0, 0)
		_old_text = text_label.text

	showname_box.global_position = showname_margin.global_position
	showname_box.set_visible(showname_label.text != "")

	dialog_box.global_position = self.global_position
	if shake_effect:
		dialog_box.position = shake_effect.get_shake_position()
		showname_margin.position = shake_effect.get_shake_position() - showname_margin.pivot_offset

func _ready():
	resized.connect(_on_resized)
	showname_margin.resized.connect(_on_showname_resized)
	shake_effect = ShakeEffect.new()
	shake_effect.initialize(text_label.position, _on_shake)

func _on_shake():
	if shake_effect:
		shake_effect.shake(self)

func _on_resized():
	dialog_box.size = self.size

func _on_showname_resized():
	showname_box.size.x = showname_margin.size.x

func _on_text_edited():
	self.size = Vector2(0, 0)

func set_showname_text(showname_text:String):
	showname_label.text = showname_text

func set_text_to_show(text_to_show:String):
	if not text_label:
		return
	command_processor.end_command_processing()
	
	text_label.set_text(text_to_show)
	for character in text_label.get_parsed_text():
		command_processor.add_command_char(character)
	text_to_show = command_processor.remove_commands_from_string(text_to_show)
	text_label.set_text(text_to_show)
	
	text_label.visible_characters = 0
	text_displayed = false

func reveal_character():
	# This does the job, though there's probably a smarter way to handle it
	if text_label.visible_characters == 0:
		command_processor.process_command(0)

	text_label.visible_characters += 1
	command_processor.process_command(text_label.visible_characters)

	var length = text_label.get_parsed_text().length()
	if(text_label.visible_characters >= length or length <= 0):
		text_displayed = true
		is_text_displayed.emit()
		command_processor.end_command_processing()

func get_current_character() -> String:
	var parsed_text = text_label.get_parsed_text()
	if parsed_text.length() <= 0:
		return ""
	return parsed_text[text_label.visible_characters-1]

func is_processing_command() -> bool:
	return command_processor.is_processing
