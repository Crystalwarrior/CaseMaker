class_name DisplayScreen

# notifies the UI when a property is updated
# so it can refresh the screen
signal updated()

# default values - private, not accessible to the parent
var _background: String = "res://assets/backgrounds/castle.png"
var _foreground: String = ""
var _text: String = ""
var _characters: Array = [] # array of character paths

# Properties.
# Rules: 
#	Properties are only set from the UI.
# 	Get should only be used by whatever triggers when updated() is emitted.
var Background: String:
	get:
		return _background
	set(value):
		_background = value
		updated.emit()

var Foreground: String:
	get:
		return _foreground
	set(value):
		_foreground = value
		updated.emit()

var Text: String:
	get:
		return _text
	set(value):
		_text = value
		updated.emit()

var Characters: Array:
	get:
		return _characters

# Functions
# Rules:
#	add_character and remove_character should be
#	treated like "set(value)" in the properties
# 	You should NEVER edit this array through the property
#	ever. Character[0] is NOT allowed.

# character_path must be a path to a character scene
func add_character(character_path:String):
	_characters.append(character_path)
	updated.emit()

func remove_character(remove_index:int):
	if(remove_index < _characters.size()):
		_characters.remove_at(remove_index)
		updated.emit()
