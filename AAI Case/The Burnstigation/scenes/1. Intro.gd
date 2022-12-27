extends Node2D

signal scene_ended()

var command_processor

# Called when the node enters the scene tree for the first time.
func _ready():
	var top = $VBoxContainer/TopLevelControl
	var bottom = $VBoxContainer/BottomScreen
	command_processor = CommandProcessor.new()
	command_processor.set_top_screen(top)
	command_processor.set_bottom_screen(bottom)
	command_processor.connect("no_more_commands", self, "on_scene_end")
	
	var bg_offset = 142
	
	top.set_bg_offset(bg_offset)
	
	top.add_mini_character(CharacterFactory.CW_MINI, 72, 78)
	top.add_mini_character(CharacterFactory.LUKE_MINI, 150, 85)
	
	top.add_big_character(CharacterFactory.make_cw(true), bg_offset )
	top.add_big_character(CharacterFactory.make_luke(true), bg_offset)
	
	bottom.set_main_button_visible()
	bottom.main_button.connect("request_command", command_processor, "on_command_request")
	
	command_processor.add_command(DialogCommand.new(CharacterFactory.CW_NAMETAG, "This is an experiment."))
	command_processor.add_command(DialogCommand.new(CharacterFactory.LUKE_NAMETAG, "Speak for yourself."))
	command_processor.add_command(FadeOutMiniCommand.new())
	command_processor.add_command(FadeBigCommand.new(CharacterFactory.LUKE_NAMETAG, Commands.CommandType.FADE_BIG_CHAR_IN))
	command_processor.add_command(DialogSpeakCommand.new(CharacterFactory.LUKE_NAMETAG, "You made me look like \nfucking Gumshoe.", "normal"))
	command_processor.add_command(DialogSpeakCommand.new(CharacterFactory.LUKE_NAMETAG, "Do I look like Gumshoe\nto you???", "normal"))
	
	command_processor.add_command(FadeBigCommand.new(CharacterFactory.LUKE_NAMETAG, Commands.CommandType.FADE_BIG_CHAR_OUT))
	command_processor.add_command(FadeBigCommand.new(CharacterFactory.CW_NAMETAG, Commands.CommandType.FADE_BIG_CHAR_IN))
	command_processor.add_command(DialogSpeakCommand.new(CharacterFactory.CW_NAMETAG, "Shut up.", "normal"))
	command_processor.add_command(DialogSpeakCommand.new(CharacterFactory.CW_NAMETAG, "Let's have a testimony about this.", "crossed"))
	command_processor.add_command(FadeBigCommand.new(CharacterFactory.CW_NAMETAG, Commands.CommandType.FADE_BIG_CHAR_OUT))
	
	command_processor.add_command(DialogCommand.new("", "(epic testimony animation here)"))

	command_processor.on_command_request()


func on_scene_end():
	emit_signal("scene_ended")
