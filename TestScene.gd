extends Node2D
@onready var next_button = get_node("%NextButton")
@onready var flash = preload("res://scenes/ScreenScenes/UpperScreen/Effects/FlashEffect.tscn")

var upper_screen
var scene_commands: Array
var scene_manager: SceneManager

func _ready():
	CommandValues.instance().eff_flash.connect(_on_flash)
	
	upper_screen = get_node("%UpperScreen")
	
	scene_commands = [ 
		create_scene_command("Edgeworth", 
		"normal",
		"{adv}Let's just hope he doesn't\nsay anything...{p 0.5} Unfortunate.",
		"Edgeworth"),
		create_scene_command("Edgeworth", 
		"normal",
		"{adv}Why of all places did the\n{e hmm}murder occur in my office?",
		"Edgeworth"),
		create_scene_command("Edgeworth", 
		"normal",
		"Oh yeah I'm {f}{s}Not Edgeworth lmao",
		"Not Edgeworth"),
		create_scene_command("Edgeworth", 
		"normal",
		"{nov}This is a story how I did your mom.{p 0.2} It's a long story so {spd_slow}{s}buckle {s}up.{p 1.0}{spd_normal} So, first, I met your mom and fuck it I'm bored {spd_fast}lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem lorem ipsum lorem lorem lorem lorem lorem lorem ",
		"LOOK MA, NOVEL MODE"),
	]
	
	scene_manager = upper_screen.create_scene_manager()
	scene_manager.get_dialog_box().text_shown.connect(_on_text_shown)
	scene_manager.set_scene_commands(scene_commands)
	
	next_button.disabled = false

func create_scene_command(nametag, animation, text, showname) -> SceneCommand:
	var command = SceneCommand.new()
	
	command.character_name = nametag
	command.character_animation = animation
	command.text_for_scene = text
	command.showname_for_scene = showname
	
	return command

func _on_flash():
	upper_screen.add_child(flash.instantiate())

func _on_text_shown():
	next_button.disabled = false

func _on_next_button_pressed():
	next_button.disabled = true
	
	if(scene_manager.scene_finished):
		scene_manager.set_scene_commands(scene_commands)
		
	scene_manager.run_next_command()
