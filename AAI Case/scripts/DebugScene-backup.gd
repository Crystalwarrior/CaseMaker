extends Node2D

# scene_paths
var confrontation_path = "res://AAI Case/scenes/ConfrontationBG.tscn"
var background_path = "res://AAI Case/backgrounds/cross5mannyPNG.png"

var cw_path = "res://AAI Case/characters/CW/CW.tscn"
var luke_path = "res://AAI Case/characters/Luke/Luke.tscn"

# misc variables
# speed for character panning
const PANNING_SPD = 0.25
var pan_fast = false

# dynamic scenes
var confrontation_scene
var cw_scene
var luke_scene

var complicated

# textbox
var dialog_box

# Called when the node enters the scene tree for the first time.
func _ready():
	dialog_box = $TopScreen/AAIDialogBox
	
	confrontation_scene = load(confrontation_path).instance()
	confrontation_scene.initialize(background_path, ConfrontationPositions.DEF)
	
	cw_scene = load(cw_path).instance()
	luke_scene = load(luke_path).instance()
	
	cw_scene.position.x = abs(confrontation_scene.DEF_POS)
	luke_scene.position.x = abs(confrontation_scene.RIVAL_POS)
	
	self.add_child(confrontation_scene)
	confrontation_scene.add_child(cw_scene)
	confrontation_scene.add_child(luke_scene)
	
	complicated = [
		[funcref(dialog_box, "display_text"), ["There were two ways to open that door.", "crossed"]],
		[funcref(dialog_box, "display_text"), ["The first was by opening the door with the master key.", "crossed"]],
		[funcref(dialog_box, "display_text"), ["The second... was with the crowbar.", "aha"]],
		[funcref(self, "luke_talk"), []],
		[funcref(self, "back_to_cw"), []]
	]
	
	dialog_box.visible = true
	dialog_box.change_character(cw_scene, "Crystalwarrior")
	_on_NextButton_pressed()
	
	dialog_box.connect("text_displayed", self, "_on_TextDisplayed")
	
func snap_to_def():
	confrontation_scene.snap_to_position(ConfrontationPositions.DEF)

func snap_to_rival():
	confrontation_scene.snap_to_position(ConfrontationPositions.RIVAL)

func pan_to_rival():
	confrontation_scene.pan_to_position(ConfrontationPositions.RIVAL, pan_fast)

func pan_to_def():
	confrontation_scene.pan_to_position(ConfrontationPositions.DEF, pan_fast)

func luke_talk():
	snap_to_rival()
	dialog_box.change_character(luke_scene, "Luke")
	dialog_box.display_text("The crowbar?", "normal")
	
func back_to_cw():
	snap_to_def()
	dialog_box.change_character(cw_scene, "Crystalwarrior")
	dialog_box.display_text("Not only that, but...", "normal")
	
var text_index = 0

var func_index = 0
var arg_index = 1

# display next text
func _on_NextButton_pressed():
	var function = complicated[text_index]
	
	var func_reference = function[func_index]
	var args = function[arg_index]
	
	if(args.size() > 0):
		func_reference.call_funcv(args)
	else:
		func_reference.call_func()
	
func _on_TextDisplayed():
	text_index += 1
	if(text_index >= complicated.size()):
		text_index = 0
