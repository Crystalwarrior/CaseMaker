extends DialogBaseNode

var expression = ""
var current_char

var chars = []

onready var characters = $Characters
onready var dialog = $HUD/Dialog

func _ready() -> void:
	preload_characters()
	dialog.connect("text_displayed", self, "_on_text_displayed")
	_set_nodes_default_values()
	start_timeline()


func preload_characters():
	var dir = Directory.new()
	var path = "res://src/Characters"
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				if file_name.ends_with(".tscn"):
					print("Preloading character: " + file_name.get_basename())
					chars.append([file_name.get_basename(), load("res://src/Characters/" + file_name) as PackedScene])
			file_name = dir.get_next()
	else:
		printerr("Warning: could not open directory: ", path)

func add_character(char_name):
	var char_scene:PackedScene
	for character in chars:
		if char_name == character[0]:
			char_scene = character[1]
	if not char_scene:
		printerr("Warning: could not find character scene: " + char_name)
		return
	var char_node = char_scene.instance()
	characters.add_child(char_node)
	expression = ""
	return char_node


func _on_text_displayed():
	if current_char == "":
		return
	var char_node = characters.get_node_or_null(current_char)
	if not char_node:
		printerr('Text Displayed - character "' + current_char + '" not found.')
		return
	var anim = expression.to_lower() + "(a)"
	var anim_player = char_node.get_node("AnimationPlayer")
	if anim_player.has_animation(anim):
		anim_player.play(anim)


func _on_event_start(_event):
	._on_event_start(_event)
	print(_event.resource_name)
	match _event.resource_name:
		"CharacterJoinEvent":
			current_char = _event.character.name
			var char_node = characters.get_node_or_null(current_char)
			if not char_node:
				char_node = add_character(current_char)
			var anim_player = char_node.get_node("AnimationPlayer")
			expression = _event.get_selected_portrait().name
			if anim_player.has_animation(expression):
				anim_player.play(expression)
			elif anim_player.has_animation(expression + "(a)"):
				anim_player.play(expression + "(a)")
		"CharacterLeaveEvent":
			var char_node = characters.get_node_or_null(current_char)
			if not char_node:
				printerr('CharacterLeaveEvent - Character "' + current_char + '" not found.')
				return
			char_node.queue_free()
			current_char = ""
		"CharacterChangeExpression":
			current_char = _event.character.name
			var char_node = characters.get_node_or_null(current_char)
			if not char_node:
				printerr('CharacterChangeExpression - Character "' + current_char + '" not found.')
				return
			var anim_player = char_node.get_node("AnimationPlayer")
			expression = _event.get_selected_portrait().name
			if anim_player.has_animation(expression):
				anim_player.play(expression)
			elif anim_player.has_animation(expression + "(a)"):
				anim_player.play(expression + "(a)")
		"TextEvent":
			if current_char == "":
				return
			var char_node = characters.get_node_or_null(current_char)
			if not char_node:
				printerr('TextEvent - Character "' + current_char + '" not found.')
				return
			var anim = expression.to_lower() + "(b)"
			var anim_player = char_node.get_node("AnimationPlayer")
			if anim_player.has_animation(anim):
				anim_player.play(anim)


func _on_event_finished(_event, go_to_next_event=false):
	._on_event_finished(_event, go_to_next_event)
	print(_event.resource_name, ' - ', go_to_next_event)


func _on_Next_pressed():
	var a = InputEventAction.new()
	a.action = "ui_accept"
	a.pressed = true
	Input.parse_input_event(a)
	yield(get_tree(),"idle_frame")
	a.pressed = false
	Input.parse_input_event(a)


func _on_Toggle_Showname_pressed():
	dialog.get_node("ShownamePanel").visible = not dialog.get_node("ShownamePanel").visible


func _on_Woosh_pressed():
	if $AnimationPlayer.current_animation == "" or $AnimationPlayer.current_animation_position == 0:
		$AnimationPlayer.play("def-pro")
	else:
		$AnimationPlayer.play_backwards("def-pro")


func _on_FlipX_pressed():
	var sprite = current_char.get_node("Sprite")
	sprite.flip_h = not sprite.flip_h


func _on_FlipY_pressed():
	var sprite = current_char.get_node("Sprite")
	sprite.flip_v = not sprite.flip_v
