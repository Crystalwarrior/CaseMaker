extends Node2D

signal scene_ended()

var command_processor
var top
var bottom

# Called when the node enters the scene tree for the first time.
func _ready():
	PersistentObjects.evidence_holder = EvidenceHolder.new()
	
	var badge = Evidence.new("res://AAI Case/evidence/images/lawyer badge.png",
								"Badge",
								"Found in your ass.",
								"It's actually your mom. You got your mom'd. Lmao.")
	# (image, name, mini, main)
	var proof = Evidence.new("res://AAI Case/evidence/images/letter.png",
								"DNA Report",
								"Received from the police.",
								"Undeniable evidence that Luke IS Gumshoe.")
	

	
	PersistentObjects.evidence_holder.add_evidence(badge)
	PersistentObjects.evidence_holder.add_evidence(proof)
	
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
	
	var cw = CharacterFactory.CW_NAMETAG
	var luke = CharacterFactory.LUKE_NAMETAG
	
	command_processor.add_command(DialogCommand.new("", "[center][color=#FF773D]-- El Poop --[/color][/center]"))
	command_processor.add_command(make_testimony())
	command_processor.add_command(PopupCommand.new("play_objection", MusicMaster.CW_OBJECTION))
	command_processor.add_command(BGMoveCommand.new(0.0, Commands.CommandType.PAN_BG))
	command_processor.add_command(PreAnimCommand.new(CharacterFactory.CW_NAMETAG, "shrug"))
	
	var commands = [
		dsch(cw, "You're NOT Gumshoe?\n", "shrug", true),
		dsch(cw, "Are you sure about that?", "aha", false, true),
		BGMoveCommand.new(-512, Commands.CommandType.SNAP_BG),
		dsch(luke, "Yeah,", "normal", true),
		dsch(luke, " look at my nametag.", "normal", false, true),
		dsch(luke, "It says \"Luke,\" not \"Gumshoe.\"", "normal"),
	]

	command_processor.commands.append_array(commands)
	command_processor.add_command(BGMoveCommand.new(0.0, Commands.CommandType.SNAP_BG))
	command_processor.on_command_request()

# helper function for dialog speaking cuz I'm lazy
func dsch(name, text, emote, auto_text = false, add_text = false):
	if(auto_text):
		return DialogSpeakCommand.new(name, text, emote, false, Commands.CommandType.DIALOG, true)
	elif(add_text):
		return DialogSpeakCommand.new(name, text, emote, true, Commands.CommandType.DIALOG_ADD)
	else:
		return DialogSpeakCommand.new(name, text, emote)
	

func make_testimony():
	var press1 = make_command_processor()
	var press2 = make_command_processor()
	var press3 = make_command_processor()
	var press4 = make_command_processor()
	
	var testimony_processor = make_command_processor()
	
	var statements = [
		DialogSpeakCommand.new(CharacterFactory.LUKE_NAMETAG, "[color=#00FF00]Statement 1: You are stupid.[/color]", "normal"),
		DialogSpeakCommand.new(CharacterFactory.LUKE_NAMETAG, "[color=#00FF00]I can have so much text. Jealous?[/color]", "normal"),
		DialogSpeakCommand.new(CharacterFactory.LUKE_NAMETAG, "[color=#00FF00]No amount of text will ever disprove the fact...[/color]", "normal"),
		DialogSpeakCommand.new(CharacterFactory.LUKE_NAMETAG, "[color=#00FF00]That I am not Gumshoe![/color]", "normal"),
	]
	
	testimony_processor.commands = statements
	
	var holdit = PopupCommand.new("play_holdit", MusicMaster.CW_HOLD_IT)
	
	var dialogp1 = [
		holdit,
		BGMoveCommand.new(0.0, Commands.CommandType.PAN_BG),
		DialogSpeakCommand.new(CharacterFactory.CW_NAMETAG, "Is that true?", "normal"),
		BGMoveCommand.new(-512, Commands.CommandType.PAN_BG),
	]
	
	press1.commands = dialogp1
	
	var press_statements = [ press1, press2, press3, press4 ]
	
	return TestimonyCommand.new(testimony_processor, press_statements, "DNA Report", 3, MusicMaster.MODERATO)

func make_command_processor():
	var cp = CommandProcessor.new()
	cp.set_top_screen(top)
	cp.set_bottom_screen(bottom)
	return cp
