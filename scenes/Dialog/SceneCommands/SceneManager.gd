class_name SceneManager
# This class is responsible for handling the state of the game scene, such as
# the present characters, the background, etc.

var characters: Dictionary = {}
var dialog_box # dialog box in scene

# Which character will be affected by mid-text emote swapping
var current_character = ""

func _init(dialog_box_scene):
	dialog_box = dialog_box_scene
	CommandValues.instance().new_emote.connect(_on_mid_sentence_emote_change)

func add_char(character_scene, character_name:String):
	if character_name in characters:
		push_warning("[SceneManager] %s already present in the scene!"%character_name)
	characters[character_name] = character_scene

func get_char(character_name:String):
	return characters[character_name] if character_name in characters else null

func remove_char(character_name:String):
	characters[character_name] = null

func get_dialog_box():
	return dialog_box

func _on_mid_sentence_emote_change(emote:String):
	if(characters.has(current_character)):
		var character = characters[current_character]
		character.set_animation(emote, character.is_talking)

