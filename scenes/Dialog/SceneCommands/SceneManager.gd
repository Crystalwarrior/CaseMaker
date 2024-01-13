class_name SceneManager

var characters: Dictionary = {}
var scene_commands:Array = [] # array of scene commands
var dialog_box # dialog box in scene

var current_command:int = 0
var scene_finished:bool = false

func _init(dialog_box_scene):
	dialog_box = dialog_box_scene
	CommandValues.instance().new_emote.connect(_on_mid_sentence_emote_change)

func add_char(character_scene, character_name:String):
	characters[character_name] = character_scene

func set_scene_commands(commands):
	scene_commands = commands
	current_command = 0

func get_dialog_box():
	return dialog_box

func get_scene_finished() -> bool:
	return scene_finished

func run_next_command():
	var command: SceneCommand = scene_commands[current_command]
	
	var character_name = command.character_name
	var character_animation = command.character_animation
	var text = command.text_for_scene
	var showname = command.showname_for_scene
	
	var character = null
	if(characters.has(character_name)):
		character = characters[character_name]
		character.set_animation(character_animation)
	
	# display name here
	if(character != null):
		character.talk()
		
	dialog_box.display_text(text, showname)
	await dialog_box.text_shown
	
	if(character != null):
		character.no_talk()
	
	current_command += 1
	if(current_command >= scene_commands.size()):
		scene_finished = true

func _on_mid_sentence_emote_change(emote:String):
	var character_name = scene_commands[current_command].character_name
	if(characters.has(character_name)):
		characters[character_name].set_animation(emote)

