extends Control
@onready var bottom_screen = get_node("%BottomScreen")
@onready var next_button = bottom_screen.next_button
@onready var choice_container = bottom_screen.choice_container
@onready var flash = preload("res://scenes/ScreenScenes/UpperScreen/Effects/FlashEffect.tscn")

@onready var upper_screen = get_node("%UpperScreen")

@onready var command_processor: CommandProcessor = get_node("%CommandProcessor")

@onready var music_player: AudioStreamPlayer = get_node("%MusicPlayer")
@onready var sfx_player: AudioStreamPlayer = get_node("%SFXPlayer")

const SFXFOLDER = "res://assets/sounds/general/"
const MUSICFOLDER = "res://assets/music/"

const EvidenceCommand = preload("res://addons/textalog/commands/command_evidence.gd")
const MusicCommand = preload("res://addons/textalog/commands/command_music.gd")

var finished: bool = false
var waiting_on_input: bool = true

var scene_manager: SceneManager
var dialog_box

signal dialog_finished
signal choice_selected(index)

func _ready():
	CommandValues.instance().eff_flash.connect(eff_flash)
	CommandValues.instance().sound_sfx.connect(play_sfx)
	CommandValues.instance().sound_music.connect(play_music)
	scene_manager = upper_screen.create_scene_manager()
	dialog_box = scene_manager.get_dialog_box()
	dialog_box.text_shown.connect(_on_text_shown)
	
	next_button.connect("button_down", _on_next_button_down)
	bottom_screen.choice_selected.connect(_on_choice_selected)


func next():
	#get_window().gui_release_focus()
	# TODO: implement skipping
	if not finished:
		if not command_processor.main_collection:
			command_processor.start()
		else:
			command_processor.go_to_next_command()


func set_waiting_on_input(tog: bool):
	waiting_on_input = tog
	next_button.disable(not waiting_on_input)
	upper_screen.set_chat_arrow_visible(waiting_on_input)


func dialog(dialog_command:Command) -> void:
	var showname = dialog_command.showname
	var dialog = dialog_command.dialog
	var letter_delay = dialog_command.letter_delay
	var blip_sound = dialog_command.blip_sound
	var hide_dialog = dialog_command.hide_dialog
	var wait_until_finished = dialog_command.wait_until_finished
	var speaking_character = dialog_command.speaking_character
	var additive = dialog_command.additive

	#TODO: use these for the characters
	var bump_speaker = dialog_command.bump_speaker
	var highlight_speaker = dialog_command.highlight_speaker

	dialog_box.current_spd = letter_delay
	if blip_sound:
		dialog_box.set_blipsound(blip_sound)
	dialog_box.show()
	dialog_box.display_text(dialog, showname, additive)
	
	scene_manager.current_character = speaking_character
	var character = scene_manager.get_char(speaking_character)
	if character:
		character.talk()

	# If we wait until finished, remember tell the timeline to continue
	if wait_until_finished:
		await dialog_finished
	if character:
		character.no_talk()
	if hide_dialog:
		dialog_box.hide()
	scene_manager.current_character = ""
	if wait_until_finished:
		dialog_command.go_to_next_command()


func character(character_command:Command) -> void:
	var character: PackedScene = character_command.character
	var character_name: String = character_command.character_name
	var emote: String = character_command.emote
	var delete: bool = character_command.delete
	var add_position: bool = character_command.add_position
	var to_position: Vector2 = character_command.to_position
	var zoom_duration: float = character_command.zoom_duration
	var flipped: bool = character_command.flipped
	var flip_duration: float = character_command.flip_duration
	var shaking:bool = character_command.shaking
	var set_z_index:int = character_command.set_z_index
	var wait_until_finished:bool = character_command.wait_until_finished
	var fade_out:bool = character_command.fade_out
	var fade_duration: float = character_command.fade_duration

	var target = scene_manager.get_char(character_name)
	if not target:
		target = character.instantiate()
		if character_name == "":
			character_name = target.name
		var existing_character = scene_manager.get_char(character_name)
		if existing_character != null:
			# Pretty silly we have to instantiate a packed scene to easily grab its data
			target.queue_free()
			target = existing_character
		else:
			upper_screen.character_container.add_child(target)
			scene_manager.add_char(target, character_name)

	if emote != "":
		target.set_animation(emote)
	if shaking:
		target.shake()
	if fade_out:
		target.fadeout(fade_duration)
	else:
		target.fadein(fade_duration)
	target.z_index = set_z_index
	target.flip_h(flipped, flip_duration)
	target.move_to(to_position, Vector2(1, 1), zoom_duration, add_position)
	# If we wait until finished, remember tell the timeline to continue
	if wait_until_finished:
		if target.waiting_on_animations > 0:
			await target.animation_finished
		character_command.go_to_next_command()
	if delete:
		scene_manager.remove_char(character_name)


func evidence(evidence_command:EvidenceCommand) -> void:
	match evidence_command.do_what:
		EvidenceCommand.Action.ADD_EVIDENCE:
			GameData.evidence_list.append(evidence_command.evidence)
		EvidenceCommand.Action.ERASE_EVIDENCE:
			GameData.evidence_list.erase(evidence_command.evidence)
		EvidenceCommand.Action.INSERT_AT_INDEX:
			GameData.evidence_list.insert(evidence_command.at_index, evidence_command.evidence)
		EvidenceCommand.Action.REMOVE_AT_INDEX:
			GameData.evidence_list.remove_at(evidence_command.at_index)
	bottom_screen.evidence_screen.load_evidence(GameData.evidence_list)


func music(music_command:MusicCommand):
	match music_command.do_what:
		music_command.Action.PLAY_MUSIC:
			music_player.play_track(music_command.music, music_command.fade_volume, music_command.fade_duration)
		music_command.Action.STOP_MUSIC:
			music_player.stop_track(music_command.fade_duration)
		music_command.Action.SET_VOLUME:
			music_player.fade(music_command.fade_volume, music_command.fade_duration)
		music_command.Action.RESUME_MUSIC:
			music_player.unpause_track(music_command.fade_volume, music_command.fade_duration)


func set_dialog_visible(toggle: bool = true):
	dialog_box.set_visible(toggle)


func multiple_choice(choices: PackedStringArray):
	upper_screen.select_your_answer(true)
	await get_tree().create_timer(0.4).timeout
	bottom_screen.multiple_choice(choices)


func eff_flash():
	upper_screen.add_child(flash.instantiate())


func play_sfx(sfx_string:String):
	if sfx_string == "":
		sfx_player.stop()
		return
	var new_stream: AudioStream
	# Direct filepath to sfx
	if ResourceLoader.exists(sfx_string, "AudioStream"):
		new_stream = load(sfx_string)
	var extension = ".wav"
	if sfx_string.get_extension() != "":
		extension = ""
	# Filename in the blips folder
	elif ResourceLoader.exists(SFXFOLDER + sfx_string + extension, "AudioStream"):
		new_stream = load(SFXFOLDER + sfx_string + extension)
	else:
		push_error("SFX ", sfx_string, " not found!")
	sfx_player.set_stream(new_stream)
	sfx_player.play()


func play_music(music_string:String = ""):
	if music_string == "":
		music_player.stop()
		return
	var new_stream: AudioStream
	# Direct filepath to sfx
	if ResourceLoader.exists(music_string, "AudioStream"):
		new_stream = load(music_string)
	var extension = ".ogg"
	if music_string.get_extension() != "":
		extension = ""
	# Filename in the music folder
	elif ResourceLoader.exists(MUSICFOLDER + music_string + extension, "AudioStream"):
		new_stream = load(MUSICFOLDER + music_string + extension)
	else:
		push_error("Music ", music_string, " not found!")
	# TODO: Crossfading, an actual music player
	music_player.set_stream(new_stream)
	music_player.play()


func _on_command_processor_collection_started(_collection):
	finished = false


func _on_command_processor_collection_finished(_collection):
	finished = true


func _on_command_processor_command_started(_command):
	set_waiting_on_input(false)


func _on_command_processor_command_finished(command):
	var command_is_waiting = not command.continue_at_end
	set_waiting_on_input(command_is_waiting)


func _on_text_shown():
	dialog_finished.emit()


func _on_next_button_down():
	next()


func _on_choice_selected(index):
	upper_screen.select_your_answer(false)
	choice_selected.emit(index)
