extends Control


## Emmited when the text is fully displayed
signal text_displayed
## Emmited eveytime that a character is displayed
signal character_displayed(character)

## The speed that the node uses to wait before adding another character.
## Values between 0.02 and 0.08 are good ones to use.
export(float) var text_speed:float = 0.02
## If true, DialogManager will try to scroll the text to fit new content
export(bool) var text_autoscroll:bool = false
## If true and [member text_autoscroll] is false, DialogManager will scale its size
## to fit its content.
export(bool) var text_fit_content_height:bool = false
## If true, DialogManager will show an VScroll to scroll its content
export(bool) var text_show_scroll_at_end:bool = true

export(NodePath) var text_timer_path
export(NodePath) var text_node_path
export(NodePath) var blip_player_path
export(NodePath) var next_indicator_path

## The node that actually displays the text
var text_node:RichTextLabel setget ,get_text_node
var text_timer:Timer
var blip_player:AudioStreamPlayer
var next_indicator:Control


## Calling this method will make to all text to be visible inmediatly
func display_all_text() -> void:
	if text_node.visible_characters >= text_node.get_total_character_count():
		return
	text_node.visible_characters = text_node.get_total_character_count() -1
	_char_position = text_node.visible_characters
	_update_displayed_text()


## Starts displaying the text setted by [method set_text]
func display_text() -> void:
	text_timer.start(text_speed)


## Set the text that this node will display. Call [method display_text]
## after using this method to display the text.
func set_text(text:String) -> void:
	text_node.bbcode_text = text
	text_node.visible_characters = 0
	_char_position = 0
	rect_min_size = _original_size
	if text_fit_content_height:
		_enable_fit_content_height()
	
	_line_count = -1
	_last_line_count = 0
	_last_wordwrap_size = Vector2()
	text_node.get_v_scroll().value = 0


## Adds text to the current one at the end. No need to call
## [method display_text] if the node is already displaying text
func add_text(text:String) -> void:
	text_node.bbcode_text = text_node.bbcode_text + text


## Returns the used text_node
func get_text_node() -> RichTextLabel:
	if is_instance_valid(text_node):
		return text_node
	return null

##########
# Private things
##########

const _DEFATULT_STRING = """This is a sample text.
[center] This'll not be displayed in game.
(At least, if you set an script to DialogBaseNode).[/center]
"""
const _PREVIEW_COLOR = Color("#6d0046ff")

var _line_count := -1
var _last_wordwrap_size := Vector2()
var _last_line_count := 0

var _original_size := Vector2()

var _char_position = 0
var _scrolling = false

func _update_displayed_text() -> void:
	if _scrolling:
		return
	
	var _character = _get_current_character()
	_on_character_displayed(_character)
	
	if text_autoscroll:
		_scroll_to_new_line()
	
	emit_signal("character_displayed", _character)
	_char_position += 1
	
	if _character in "\t\n\r":
		_update_displayed_text()
		return
	
	text_node.set_deferred("visible_characters", text_node.visible_characters+1)
	
	if text_node.visible_characters >= text_node.get_total_character_count()-1:
		text_timer.stop()
		_char_position = text_node.get_total_character_count()
		emit_signal("text_displayed")
		
		if text_show_scroll_at_end:
			_show_scroll()
	else:
		text_timer.start(text_speed)

func _on_character_displayed(character:String) -> void:
	blip_player._on_character_displayed(character)

func _update_original_size() -> void:
	_original_size = rect_size


func _enable_fit_content_height():
	if !text_autoscroll:
		text_node.fit_content_height = true


func _disable_fit_content_height():
	text_node.fit_content_height = false


func _show_scroll() -> void:
	text_node.scroll_active = true


func _hide_scroll() -> void:
	text_node.scroll_active = false


# This doesn't works too well with text_speed < 0.1 and q_max_lines <= 3
func _scroll_to_new_line() -> void:
	var height := text_node.get_content_height()
	var font := text_node.get_font("normal_font")
	var font_height := font.get_height()+get_constant("line_separation", "RichTextLabel")
	var scroll := text_node.get_v_scroll()

	var current_text = text_node.text.left(_char_position)
	var wordwrap_size:Vector2= font.get_wordwrap_string_size(current_text, text_node.rect_size.x)
	var text_container_height = text_node.rect_size.y
	
	var q_max_lines = int(text_container_height/font_height)
	var visible_line_count = text_node.get_visible_line_count()
	
	var _need_to_scroll = false
	
	if wordwrap_size.y > _last_wordwrap_size.y:
		_line_count += 1
		var space_left = text_container_height-wordwrap_size.y
		
		# Negative value? That means we've reached the end of the container
		# Scroll that thing!
		if space_left < 0:
			_need_to_scroll = true
	
	if _need_to_scroll:
		var tween = Tween.new()
		tween.connect("tween_all_completed", tween, "queue_free")
		tween.connect("tween_all_completed", self, "set", ["_scrolling", false])
		tween.connect("tween_all_completed", text_timer, "start", [text_speed])
		get_tree().root.add_child(tween)
		tween.interpolate_property(scroll, "value", null, scroll.value+font_height, 0.8)
		_scrolling = true
		tween.start()
		
#		scroll.set_deferred("value", scroll.value+font_height)
		
	_last_wordwrap_size = wordwrap_size
	_last_line_count = _line_count


func _get_current_character() -> String:
	var _text:String = text_node.text
	
	if _text == "":
		_text = " "
	
	var _text_length = _text.length()-1
	var _text_visible_characters = clamp(_char_position, 0, _text_length)
	var _current_character = _text[min(_text_length, _text_visible_characters)]
	return _current_character

func _init() -> void:
	text_timer = get_node_or_null(text_timer_path)
	text_timer.connect("timeout", self, "_update_displayed_text")

	text_node = get_node_or_null(text_node_path)

	var scroll := text_node.get_v_scroll()
	if Engine.editor_hint:
		connect("draw", text_node, "set", ["bbcode_text", _DEFATULT_STRING])
	
	blip_player = get_node_or_null(blip_player_path)
	next_indicator = get_node_or_null(next_indicator_path)
