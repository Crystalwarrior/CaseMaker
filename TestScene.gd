extends Node2D
@onready var next_button = get_node("%NextButton")
@onready var chat_arrow = get_node("%ChatArrow")
@onready var big_arrow = get_node("%BigArrow")
@onready var flash = preload("res://scenes/ScreenScenes/UpperScreen/Effects/FlashEffect.tscn")
@onready var dink_player = $NextButton/AudioStreamPlayer

var upper_screen
var scene_commands: Array
var scene_manager: SceneManager

func _ready():
	CommandValues.instance().eff_flash.connect(_on_flash)
	
	upper_screen = get_node("%UpperScreen")
	
	scene_commands = [ 
		create_scene_command("", 
		"",
		"{adv}{blip sans}watch out sans is here {p 0.5}*kills*{p 2.0}...",
		"",
		false),
		create_scene_command("", 
		"",
		"{adv}{blip typewriter}{spd_typewriter}[center][color=green]August 3, 9:47 AM\nDistrict Court\nDefendant Lobby No. 2",
		""),
		create_scene_command("Edgeworth", 
		"normal",
		"{blip female}Let's just hope he doesn't\nsay anything...{p 0.4} Unfortunate.",
		"Edgeworth"),
		create_scene_command("Edgeworth", 
		"normal",
		"{blip male}Why of all places did the\n{e hmm}murder occur in my office?",
		"Edgeworth"),
		create_scene_command("Edgeworth", 
		"normal",
		"{blip sans}sans undertale eh heh heheheh eheheheheh",
		"SANS UNDERTALE"),
		create_scene_command("Edgeworth", 
		"normal",
		"{nov}This is a story how I did your mom.{p 0.2} It's a long story so {spd_slow}{s}buckle {s}up.{p 1.0}{spd_normal}\nSo, first, I met your mom and fuck it I'm bored {spd_fast}lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem lorem ipsum lorem lorem lorem lorem lorem",
		"LOOK MA, NOVEL MODE"),
	]
	
	scene_manager = upper_screen.create_scene_manager()
	scene_manager.get_dialog_box().text_shown.connect(_on_text_shown)
	scene_manager.set_scene_commands(scene_commands)
	
	next_button.disabled = false

func create_scene_command(nametag, animation, text, showname, wait_for_input = true) -> SceneCommand:
	var command = SceneCommand.new()
	
	command.character_name = nametag
	command.character_animation = animation
	command.text_for_scene = text
	command.showname_for_scene = showname
	command.wait_for_input = wait_for_input
	
	return command

func _on_flash():
	upper_screen.add_child(flash.instantiate())

func _on_text_shown():
	if(not scene_manager.scene_commands[scene_manager.current_command].wait_for_input):
		await get_tree().process_frame
		scene_manager.run_next_command()
		return
	next_button.disabled = false
	chat_arrow.visible = true
	big_arrow.visible = true
	

func _on_next_button_pressed():
	next_button.disabled = true
	chat_arrow.visible = false
	big_arrow.visible = false
	
	if(scene_manager.scene_finished):
		scene_manager.scene_finished = false
		scene_manager.set_scene_commands(scene_commands)
	dink_player.play()
	scene_manager.run_next_command()
