class_name DialogCommand

var _nametag
var _text
var _command_type

func _init(nametag, text):
	_nametag = nametag
	_text = text
	_command_type = Commands.CommandType.DIALOG
	
