# All an AA button has to do is increment through text until it's done
extends Control

signal command_processed()
signal end_reached()

# an array of function references
# should only be set to, never taken from
var command_array

# the point where we start, and the point where we end
var current_index = 0

# indexes for function calls
const FUNCTION = 0
const ARGS = 1
const TIMEOUT = 2

# change the command array and reset our current_index
func set_command_array(new_command_array):
	command_array = new_command_array
	current_index = 0
	_on_MainButton_pressed()


# process commands at the current index
func process_command():
	var commands = command_array[current_index]
	
	if(commands.size() > 0):
		
		for i in range(commands.size() - 1):
			var command = commands[i]

			command[FUNCTION].call_funcv(command[ARGS])
			
			if(command.size() == 3):
				yield(get_tree().create_timer(command[TIMEOUT]), "timeout")
		
		commands[commands.size() - 1] = true

func _on_MainButton_pressed():
	process_command()

	current_index += 1
	
	if(current_index == command_array.size()):
		# this should be handled in the scene parent
		# if it is unhandled, the program should crash
		emit_signal("end_reached")
