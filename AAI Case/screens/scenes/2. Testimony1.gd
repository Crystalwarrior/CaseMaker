extends Node2D

signal scene_ended()

var command_processor
var top
var bottom

# Called when the node enters the scene tree for the first time.
func _ready():
	top = $VBoxContainer/TopLevelControl
	bottom = $VBoxContainer/BottomScreen
	command_processor = CommandProcessor.new()
	command_processor.set_top_screen(top)
	command_processor.set_bottom_screen(bottom)
	
	top.add_big_character(CharacterFactory.make_cw())
	top.add_big_character(CharacterFactory.make_luke(), 512)
	top.change_bg_position(-512)
	
	bottom.set_main_button_visible()
	bottom.main_button.connect("request_command", command_processor, "on_command_request")
	
	command_processor.add_command(DialogCommand.new("", "[center][color=#FF773D]-- El Poop --[/color][/center]"))
	command_processor.add_command(make_testimony())
	
	command_processor.on_command_request()

func make_testimony():
	var press1 = make_command_processor()
	var press2 = make_command_processor()
	var press3 = make_command_processor()
	var press4 = make_command_processor()
	
	var testimony_processor = make_command_processor()
	
	var statements = [
		DialogSpeakCommand.new(CharacterFactory.LUKE_NAMETAG, "[color=#00FF00]Statement 1: You are stupid.[/color]", "normal"),
		DialogSpeakCommand.new(CharacterFactory.LUKE_NAMETAG, "[color=#00FF00]I can have so much text. Jealous?[/color]", "normal"),
		DialogSpeakCommand.new(CharacterFactory.LUKE_NAMETAG, "[color=#00FF00]No amount of text will ever convince me...[/color]", "normal"),
		DialogSpeakCommand.new(CharacterFactory.LUKE_NAMETAG, "[color=#00FF00]That I am, in any way, Gumshoe![/color]", "normal"),
	]
	
	testimony_processor.commands = statements
	
	var dialogp1 = [
		BGMoveCommand.new(0.0, Commands.CommandType.PAN_BG),
		DialogSpeakCommand.new(CharacterFactory.CW_NAMETAG, "Is that true?", "normal"),
		BGMoveCommand.new(-512, Commands.CommandType.PAN_BG),
	]
	
	press1.commands = dialogp1
	
	var press_statements = [ press1, press2, press3, press4 ]
	
	return TestimonyCommand.new(testimony_processor, press_statements, MusicMaster.MODERATO)

func make_command_processor():
	var cp = CommandProcessor.new()
	cp.set_top_screen(top)
	cp.set_bottom_screen(bottom)
	return cp
