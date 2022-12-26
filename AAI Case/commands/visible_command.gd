class_name VisibleCommand

var _nametag
var _visible
var _command_type

func _init(nametag, visible):
	_nametag = nametag
	_visible = visible
	_command_type = Commands.CommandType.CHAR_VISIBLE
