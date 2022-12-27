class_name DialogSpeakCommand

var _emote
var _dialog_command
var _command_type
var _pause_before

func _init(nametag, text, emote, pause = false, dialog = Commands.CommandType.DIALOG, auto_skip = false):
	_emote = emote
	
	_pause_before = pause
	
	if(_pause_before):
		pause = false
	
	_dialog_command = DialogCommand.new(nametag, text, pause, dialog, auto_skip)
	_command_type = Commands.CommandType.BIG_SPEAK
