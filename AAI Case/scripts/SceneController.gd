extends Node

signal end_reached()

enum CommandType {
	DIALOG_SPEAKING, 
	DIALOG_THINKING, 
	SHOUT_BUBBLE,
	SCREEN_PAN,
	SCREEN_SNAP
}

# the point where we start, and the point where we end
var current_index = 0
var can_accept_commands = true
var command_array = [] # array of command dictionaries

# the dialog_box for the scene
var dialog_box

# command = {
#		"command_type" : command_type,
#		"node" : node
#		... (command_specific_actions) ...
# }

# helper function for adding a snap command during confrontations
func add_snap_to_pos(background, position):
	var background_snap = {
		"command_type": CommandType.SCREEN_SNAP,
		"background": background,
		"position": position
	}
	
	command_array.append(background_snap)


const DEFAULT_IS_SEEN = false

# helper function for adding a speaking character to a scene
func add_character_speaking(character, emote_string, text):
	var speaking_command = {
		"command_type": CommandType.DIALOG_SPEAKING,
		"character": character,
		"emote": emote_string,
		"text": text,
		"is_seen": DEFAULT_IS_SEEN
	}
	
	command_array.append(speaking_command)
	
	
# process only the first command
# this should be used at the start of a scene
func process_first_command():
	if(current_index == 0):
		_on_Command_Request()


func process_command():
	# no new commands when one is processing
	can_accept_commands = false
	
	var command = command_array[current_index]
	var command_type = command["command_type"]
	
	match command_type:
		CommandType.DIALOG_SPEAKING:
			display_text(command)
		CommandType.SCREEN_SNAP:
			screen_snap(command)
		CommandType.SHOUT_BUBBLE:
			pass


func display_text(command):
	# have a dialog box node
	var character = command["character"]
	var text = command["text"]
	var emote = command["emote"]
	var is_seen = command["is_seen"]
			
	dialog_box.change_character(character)
	dialog_box.display_text(text, emote)
			
	# if we're seeing this text for the first time, hold until it's completed
	if(!is_seen):
		yield(dialog_box, "text_displayed")
		yield(get_tree().create_timer(0.5), "timeout")
		command["is_seen"] = true
	
	can_accept_commands = true


func screen_snap(command):
	var background = command["background"]
	var position = command["position"]
			
	background.snap_to_position(position)
	can_accept_commands = true
	
	# we have to do this in reverse to avoid infinite loop
	current_index += 1
	process_command()


func _on_Command_Request():
	if(can_accept_commands):
		process_command()
		current_index += 1
		
		if(current_index == command_array.size()):
			emit_signal("end_reached")