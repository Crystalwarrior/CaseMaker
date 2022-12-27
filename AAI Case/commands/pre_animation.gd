class_name PreAnimCommand

var _nametag
var _animation
var _command_type

func _init(nametag, animation):
	_nametag = nametag
	_animation = animation
	_command_type = Commands.CommandType.PRE_ANIM
