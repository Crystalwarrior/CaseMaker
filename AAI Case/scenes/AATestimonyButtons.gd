extends "res://AAI Case/scenes/AAButton.gd"

signal show_press_dialog()
signal show_present_menu()

# last played index in the testimony is always 0 since it plays on startup
var last_played = 0
# the presses for the current statement we're on
var press_array = []

func set_command_array(new_command_array):
	.set_command_array(new_command_array)
	current_index = 0

# set our press conversation and save our call_back_statement if we press it
func set_press_conversation(array):
	press_array = array

func decrement_current_index():
	current_index -= 1
	
	if(current_index < 0):
		current_index = 0
	
func increment_current_index():
	current_index += 1
	
	# if the next index afterward is the size of the array, then loop testimony
	if(current_index == command_array.size()):
		current_index = 0


func _on_LeftButton_pressed():
	decrement_current_index()
	
	# if we're still on the same statement
	# as what was last played, move left one more
	if(last_played == current_index):
		decrement_current_index()
	
	# plays the command, and lets the program know that
	# the next thing we want to see is current_index + 1
	process_command()
	
	last_played = current_index


func _on_RightButton_pressed():
	# if the next index is the same as the last one we just played
	# increment the current index
	increment_current_index()
	
	if(current_index == last_played):
		increment_current_index()

	# our index is always incremented on start up
	# we show first, increment second
	process_command()
	
	last_played = current_index
	

func _on_PressBtn_pressed():
	emit_signal("show_press_dialog")


func _on_PresentBtn_pressed():
	emit_signal("show_present_menu")
