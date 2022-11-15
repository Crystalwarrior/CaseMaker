extends Node2D

# scene_paths
var confrontation_path = "res://AAI Case/scenes/ConfrontationBG.tscn"
var background_path = "res://AAI Case/backgrounds/cross5mannyPNG.png"

onready var cw_path = "res://AAI Case/characters/CW/CW.tscn"
onready var luke_path = "res://AAI Case/characters/Luke/Luke.tscn"

# misc variables
# speed for character panning
const PANNING_SPD = 0.25
var pan_fast = false

# dynamic scenes
var confrontation_scene
var cw_scene
var luke_scene

var current_character
var emote

onready var dialog = $TopScreen/AAIDialogBox

onready var scene_dialog = [
	["This is a line of text I'm using to test.", "normal"],
	["This is a secondary line of text I am using to test.", "crossed"],
	["Here is the final line of text I'm using to test.", "aha"]
]

# Called when the node enters the scene tree for the first time.
func _ready():
	# load confrontation scene
	initializeBackground(confrontation_path, background_path, ConfrontationPositions.DEF)
	
	# initialize and place characters in the scene
	cw_scene = CharacterFactory.make_CW_scene()
	luke_scene = CharacterFactory.make_Luke_scene()
	
	cw_scene.position.x = abs(confrontation_scene.DEF_POS)
	luke_scene.position.x = abs(confrontation_scene.RIVAL_POS)

	self.add_child(confrontation_scene)
	confrontation_scene.add_child(cw_scene)
	confrontation_scene.add_child(luke_scene)
	
	###########################################
	
	dialog.visible = true
	current_character = cw_scene
	dialog.change_character(current_character, "Crystalwarrior")

	# post_anim = "normal(a)"
	# current_char.play("normal(b)")
	# yield(get_tree().create_timer(1.25), "timeout")
	# post_anim = "confident(a)"
	# current_char.play("confident(b)")
	# $SFXPlayer.set_stream(load("res://res/Sounds/damage1.wav"))
	# $SFXPlayer.play()
	# dialog.add_text(" AND dad!")
	# dialog.display_text()

func initializeBackground(confrontation_scene_path, background_image_path, starting_position):
	confrontation_scene = load(confrontation_scene_path).instance()
	confrontation_scene.initialize(background_image_path, starting_position)

func snap_to_def():
	confrontation_scene.snap_to_position(ConfrontationPositions.DEF)

func snap_to_rival():
	confrontation_scene.snap_to_position(ConfrontationPositions.RIVAL)

func pan_to_rival():
	confrontation_scene.pan_to_position(ConfrontationPositions.RIVAL, pan_fast)

func pan_to_def():
	confrontation_scene.pan_to_position(ConfrontationPositions.DEF, pan_fast)
	
var text_index = 0

var func_index = 0
var arg_index = 1

# display next text
func _on_NextButton_pressed():
	var current_dialog = scene_dialog[text_index]
	var text = current_dialog[0]
	var emote = current_dialog[1]
	dialog.display_text(text, emote)
	
	text_index += 1
	if(text_index >= scene_dialog.size()):
		text_index = 0


