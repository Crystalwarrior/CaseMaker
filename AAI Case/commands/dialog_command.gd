class_name DialogCommand

var _nametag
var _text
var _command_type
var _pause_before # pause before playing the text
var _auto_continue # don't wait for the user to push anything
var _seen

func _init(nametag, text, pause = false, dialog = Commands.CommandType.DIALOG, auto_continue = false):
	_nametag = nametag
	_text = text
	_command_type = dialog
	_pause_before = pause
	_auto_continue = auto_continue
	_seen = false
	
