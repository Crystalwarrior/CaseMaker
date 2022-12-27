class_name PopupCommand

var _popup_func
var _sfx_name
var _command_type

func _init(func_string, sfx_path = "res://AAI Case/sfx/objection.wav"):
	_popup_func = func_string
	_sfx_name = sfx_path
	_command_type = Commands.CommandType.POPUP
