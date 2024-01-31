@tool
class_name TextCommandProcessor

var is_processing:bool = false
var command_processed:bool = false

var cmd_index:int = 0
var cmd_dict = {}

var cmdvs:CmdValues = CommandValues.instance()

# build up the command we want to run
# format is "{cmd value}" or "{cmd}"
func add_command_char(command_char:String):
	if(command_char == "{"):
		add_command_to_dict(command_char)
		is_processing = true
		
	elif(command_char == "}"):
		add_command_to_dict(command_char)
		is_processing = false
		
	elif(is_processing):
		add_command_to_dict(command_char)
		
	else:
		cmd_index += 1


func add_command_to_dict(command_char:String):
	if(cmd_dict.has(cmd_index)):
		cmd_dict[cmd_index] += command_char
	else:
		cmd_dict[cmd_index] = command_char

func remove_commands_from_string(full_text:String) -> String:
	for key in cmd_dict.keys():
		full_text = remove_string(full_text, cmd_dict[key])
		
	return full_text


func remove_string(string: String, removal: String) -> String:
	var length = removal.length()
	var i = 0
	while i < string.length():
		var piece = ''
		var j = i

		while j < i + length:
			piece += string[j]
			j += 1

		if piece == removal:
			return string.substr(0, j - length) + string.substr(j)

		i += 1

	return string


func process_command(index:int):
	if(!cmd_dict.has(index)):
		return
	
	var command = cmd_dict[index]
	command = command.lstrip("{")
	command = command.rstrip("}")
	var cmd_split:PackedStringArray = command.split("}{")
	
	for split_cmd in cmd_split:
		var cmd = split_cmd.split(" ")
		if(cmd.size() > 1):
			cmdvs.handle_effect(cmd[0], cmd[1])
		else:
			cmdvs.handle_effect(cmd[0])

func end_command_processing():
	cmd_dict.clear()
	cmd_index = 0
