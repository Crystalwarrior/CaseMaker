class_name DialogSpeakCommand

var _emote
var _dialog_command
var _command_type
var _make_visible

func _init(nametag, text, emote, make_visible = true):
	_emote = emote
	_dialog_command = DialogCommand.new(nametag, text)
	_command_type = Commands.CommandType.BIG_SPEAK
	_make_visible = make_visible
