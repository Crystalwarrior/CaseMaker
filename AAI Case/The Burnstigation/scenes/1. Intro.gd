extends Node2D

signal scene_ended()

var command_processor

# Called when the node enters the scene tree for the first time.
func _ready():
	var top = $VBoxContainer/TopLevelControl
	var bottom = $VBoxContainer/BottomScreen
	
	# setup code
	command_processor = CommandProcessor.new()
	command_processor.set_top_screen(top)
	command_processor.set_bottom_screen(bottom)
	command_processor.connect("no_more_commands", self, "on_scene_end")
	bottom.set_main_button_visible()
	bottom.main_button.connect("request_command", command_processor, "on_command_request")
	
	# actual scene events
	nameless_dialog("Our story begins in a country known as the Master City.")
	nameless_dialog("The Master City is a small nation divided into districts called \"servers.\"")
	nameless_dialog("Each server has a host who acts as its governor.")
	nameless_dialog("In the beginning,## there could be infinite servers of any size.")
	nameless_dialog("Within each server was a population specializing in a specific brand of [color=#FF773D]casing.[/color]")
	nameless_dialog("For decades this system of free casing remained in place until... it happened.")
	nameless_dialog("In 2015,## an tragedy known as the \"AO-V Incident\" changed the Master City as everyone knew it.")
	nameless_dialog("Casing was destroyed, servers fell left and right...")
	nameless_dialog("A massive power vacuum was created as several factions tried to step in to maintain some kind of order.")
	nameless_dialog("Amidst this chaos came a group known as [color=#FF773D]Attorney Official.[/color]")
	nameless_dialog("Somehow, they managed to overpower everyone else and gain control of the Master City.")
	nameless_dialog("In the end, the laws of the land were changed.")
	nameless_dialog("Casing is no longer as simple as it used to be.")
	# fade in JC and CW here
	nameless_dialog("This is the story of two survivors from this era...")
	nameless_dialog("...trying to make sense of the new era AO has ushered in.")
	# stop music - make this typewriter speak
	nameless_dialog("[center][color=#FF773D]The Burnstigation[/color][/center]")

	command_processor.on_command_request()

# i'm too lazy to write this out every 5 seconds so this command will just put up a nameless dialogbox for the intro
func nameless_dialog(text):
	command_processor.add_command(DialogCommand.new("", text))

func on_scene_end():
	emit_signal("scene_ended")
