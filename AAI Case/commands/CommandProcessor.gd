extends Node

signal no_more_commands()

const TIMER_SPD = 0.1
const PAN_SPD = 0.5

class_name CommandProcessor

var commands = []
var command_index = 0

var top_screen_node
var bottom_screen_node

func set_top_screen(top_screen):
	top_screen_node = top_screen

func set_bottom_screen(bottom_screen):
	bottom_screen_node = bottom_screen

func add_command(command):
	commands.append(command)

func reset_commands():
	commands = []

func on_command_request():
	if(command_index == commands.size()):
		emit_signal("no_more_commands")
	else:
		var command = commands[command_index]
		process_command(command)

func process_command(command):
	match(command._command_type):
		Commands.CommandType.DIALOG:
			top_screen_node.dialog.change_nametag(command._nametag)
			top_screen_node.dialog.display_text(command._text)
			increment_command_index()
			
		Commands.CommandType.FADE_MINIS_OUT:
			top_screen_node.background.fade_to_grey()
			top_screen_node.hide_mini_characters_in_seen()
			top_screen_node.dialog.visible = false
			
			# yields are local to the function, have to repaste this line
			top_screen_node.timer.start(TIMER_SPD)
			yield(top_screen_node.timer, "timeout")
			
			force_command_progress()
		
		Commands.CommandType.FADE_BIG_CHAR_IN:
			top_screen_node.fade_in_big_character(command._character_name)
			
			# yields are local to the function, have to repaste this line
			top_screen_node.timer.start(TIMER_SPD)
			yield(top_screen_node.timer, "timeout")
			
			force_command_progress()
		
		Commands.CommandType.FADE_BIG_CHAR_OUT:
			top_screen_node.dialog.visible = false
			top_screen_node.fade_out_big_character(command._character_name)
			
			# yields are local to the function, have to repaste this line
			top_screen_node.timer.start(TIMER_SPD)
			yield(top_screen_node.timer, "timeout")
			
			force_command_progress()
		
		Commands.CommandType.BIG_SPEAK:
			var character = top_screen_node.get_big_char_by_nametag(command._dialog_command._nametag)
			
			character.make_character_talk(command._emote)
			
			process_command(command._dialog_command)
			yield(top_screen_node.dialog, "text_displayed")
			
			character.make_character_idle(command._emote)
			
			
		Commands.CommandType.CHAR_VISIBLE:
			top_screen_node.change_big_character_visible(command._nametag, command._visible)
			force_command_progress()
		
		
		Commands.CommandType.SNAP_BG:
			top_screen_node.snap_over_bg(command._position)
			force_command_progress()


		Commands.CommandType.PAN_BG:
			top_screen_node.dialog.visible = false
			top_screen_node.pan_over_bg(command._position)
			top_screen_node.timer.start(PAN_SPD)
			yield(top_screen_node.timer, "timeout")
			force_command_progress()
		
		
		Commands.CommandType.TESTIMONY:
			command.start_testimony()
			bottom_screen_node.main_button.disconnect("request_command", self, "on_command_request")
			yield(command, "testimony_over")
			bottom_screen_node.main_button.connect("request_command", self, "on_command_request")
			force_command_progress()
		

func force_command_progress():
	increment_command_index()
	on_command_request()

func increment_command_index():
	command_index += 1
