extends Node

class_name DialogEvent

# the name of the speaker, can be empty if no showname
var speaker_nametag: String

# the character's emote during this dialog segment
var emote: String

# int from an autoload class, tells us where on the screen the
# character should be for this dialog
# leave -1 if no change should be made
var screen_position = -1

# tells us whether or not the character fades
# in on entrance
var char_appearance_enum = CharacterEffectEnums.CharAppearanceEnum.NONE

# the dialog string
var dialog: String

# whether or not the dialog has been seen already
var is_seen: bool

func post_dialog(character_scene, dialog_box):
	
	dialog_box.change_character(speaker_nametag)
	dialog_box.display_text(dialog)
