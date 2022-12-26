# Basic Scene Test is template for the basic workflow of this project
extends Node2D

# characters
onready var CW = $ConfrontationBG/CW
onready var Luke = $ConfrontationBG/Luke
onready var dialog_box = $CanvasLayer/AAIDialogBox
onready var background = $ConfrontationBG
onready var aa_button = $AAButton
onready var aa_testimony_btns = $TestimonyButtons
onready var evidence = $Evidence

onready var music_player = $MusicPlayer

# a variable that tracks what to do next when each scene finishes
var array_progress_tracker = 0

# be default, it's assumed that all frames aren't seen
# if they are seen, we can skip them accordingly
# this must always be put at the end
const DEFAULT_IS_SEEN = false

const TIMEOUT_VALUE = 0.8
const PAN_SPEED = 0.7

# testimony variables
var in_testimony = false
var testimony_start_index = 0
var testimony_end_index = 0

# structure -- we do this so we have something to jump back to on save reloads
# 1. top level arrays = "frames"
# 2. events executed within a frame
# 3. at the end of each event is a boolean as to whether or not it was seen
onready var scene_events = [
	[
		[ funcref(self, "snap_to_CW"), []],
		[ funcref(dialog_box, "display_text"), ["With THIS line of dialog,\nI'll win the battle.", "crossed"]],
		DEFAULT_IS_SEEN
	],
	[
		[ funcref(self, "snap_to_Luke"), []],
		[ funcref(dialog_box, "display_text"), ["You cannot win this battle.\nIt's not possible.", "normal"]],
		DEFAULT_IS_SEEN
	],
	[
		[ funcref(dialog_box, "display_text"), ["This text is far superior.", "normal"]],
		DEFAULT_IS_SEEN
	],
	[
		[ funcref(self, "snap_to_CW"), []],
		[ funcref(dialog_box, "display_text"), ["Oh yeah? Well...", "normal"]],
		DEFAULT_IS_SEEN
	],
	[
		[ funcref(self, "snap_to_Luke"), []],
		[ funcref(dialog_box, "display_text"), ["\"Well\" nothing.\nTime for a cross-examination.", "normal"]],
		DEFAULT_IS_SEEN
	],
	[
		[ funcref(self, "increment_tracker"), []],
		[ funcref(music_player, "set_stream"), [load("res://AAI Case/music/questioning_moderato.ogg")]],
		[ funcref(music_player, "play"), []],
		DEFAULT_IS_SEEN
	],
]

onready var press1 = [
	[
		[ funcref(self, "toggle_dialog_visibility"), []],
		[ funcref(self, "hold_it_CW"), [], TIMEOUT_VALUE],
		[ funcref(self, "pan_to_CW"), [], PAN_SPEED],
		[ funcref(self, "toggle_dialog_visibility"), []],
		[ funcref(dialog_box, "display_text"), ["Is this statement 1?", "normal"]],
		DEFAULT_IS_SEEN
	],
	[
		[ funcref(self, "snap_to_Luke"), []],
		[ funcref(dialog_box, "display_text"), ["Yes. It is statement 1.", "normal"]],
		DEFAULT_IS_SEEN
	],
	[]
]

onready var press2 = [
	[
		[ funcref(self, "toggle_dialog_visibility"), []],
		[ funcref(self, "hold_it_CW"), [], TIMEOUT_VALUE],
		[ funcref(self, "pan_to_CW"), [], PAN_SPEED],
		[ funcref(self, "toggle_dialog_visibility"), []],
		[ funcref(dialog_box, "display_text"), ["Is this statement 2?", "normal"]],
		DEFAULT_IS_SEEN
	],
	[
		[ funcref(self, "snap_to_Luke"), []],
		[ funcref(dialog_box, "display_text"), ["Yes. It is statement 2.", "normal"]],
		DEFAULT_IS_SEEN
	],
	[]
]

onready var press3 = [
	[
		[ funcref(self, "toggle_dialog_visibility"), []],
		[ funcref(self, "hold_it_CW"), [], TIMEOUT_VALUE],
		[ funcref(self, "pan_to_CW"), [], PAN_SPEED],
		[ funcref(self, "toggle_dialog_visibility"), []],
		[ funcref(dialog_box, "display_text"), ["Is this statement 3?", "normal"]],
		DEFAULT_IS_SEEN
	],
	[
		[ funcref(self, "snap_to_Luke"), []],
		[ funcref(dialog_box, "display_text"), ["Yes. It is statement 3.", "normal"]],
		DEFAULT_IS_SEEN
	],
	[]
]

onready var press4 = [
	[
		[ funcref(self, "toggle_dialog_visibility"), []],
		[ funcref(self, "hold_it_CW"), [], TIMEOUT_VALUE],
		[ funcref(self, "pan_to_CW"), [], PAN_SPEED],
		[ funcref(self, "toggle_dialog_visibility"), []],
		[ funcref(dialog_box, "display_text"), ["Is this statement 4?", "normal"]],
		DEFAULT_IS_SEEN
	],
	[
		[ funcref(self, "snap_to_Luke"), []],
		[ funcref(dialog_box, "display_text"), ["Yes. It is statement 4.", "normal"]],
		DEFAULT_IS_SEEN
	],
	[]
]

onready var testimony1 = [
	[
		[ funcref(dialog_box, "display_text"), ["[color=#00FF00]Behold, the first statement.[/color]", "normal"]],
		[ funcref(aa_testimony_btns, "set_press_conversation"), [press1]],
		DEFAULT_IS_SEEN
	],
	[
		[ funcref(dialog_box, "display_text"), ["[color=#00FF00]This is the second statement.\nJealous?[/color]", "normal"]],
		[ funcref(aa_testimony_btns, "set_press_conversation"), [press2]],
		DEFAULT_IS_SEEN
	],
	[
		[ funcref(dialog_box, "display_text"), ["[color=#00FF00]Number three. This one is a doozy.[/color]", "normal"]],
		[ funcref(aa_testimony_btns, "set_press_conversation"), [press3]],
		DEFAULT_IS_SEEN
	],
	[
		[ funcref(dialog_box, "display_text"), ["[color=#00FF00]Four: the contradiction.[/color]", "normal"]],
		[ funcref(aa_testimony_btns, "set_press_conversation"), [press4]],
		DEFAULT_IS_SEEN
	]
]

# input = { "text": "text", "desc": "desc" }
onready var evidence_dict = {
	"id" : 1,
	"ev_name" : "Your Mom Joke",
	"desc" : "Sometimes, you need something that\nwill end a debate in a nanosecond.\nThe mom joke is that debate killer.\nImpossible to lose with\nthis piece of evidence."
}

func _ready():
	aa_button.set_command_array(scene_events)
	aa_button.connect("end_reached", self, "_on_Command_Array_Finished")
	
	evidence.add_evidence(evidence_dict)

func hold_it_CW():
	$SFXPlayer.set_stream(load("res://AAI Case/sfx/cw_holdit.wav"))
	$SFXPlayer.play()
	$CanvasLayer/Bubble/AnimationPlayer.play("holdit")

# helper functions
func snap_to_CW():
	background.snap_to_position(ConfrontationPositions.DEF)
	dialog_box.change_character(CW)
	
func snap_to_Luke():
	background.snap_to_position(ConfrontationPositions.RIVAL)
	dialog_box.change_character(Luke)
	
func pan_to_CW():
	background.pan_to_position(ConfrontationPositions.DEF)
	dialog_box.change_character(CW)
	
func pan_to_Luke():
	background.pan_to_position(ConfrontationPositions.RIVAL)
	dialog_box.change_character(Luke)

func toggle_btn_visibility():
	aa_button.visible = !aa_button.visible
	aa_testimony_btns.visible = !aa_testimony_btns.visible

func toggle_dialog_visibility():
	dialog_box.visible = !dialog_box.visible


# scene management functions
func increment_tracker():
	array_progress_tracker += 1


func _on_Command_Array_Finished():
	match(array_progress_tracker):
		1:
			aa_button.disconnect("end_reached", self, "_on_Command_Array_Finished")
			toggle_btn_visibility()
			
			aa_testimony_btns.set_command_array(testimony1)
			aa_testimony_btns.connect("show_press_dialog", self, "_on_Show_Press_Dialog")
			aa_testimony_btns.connect("show_present_menu", self, "_on_Show_Present_Dialog")


func _on_Show_Press_Dialog():
	toggle_btn_visibility()
	
	aa_button.connect("end_reached", self, "_on_Press_Finished")
	aa_button.set_command_array(aa_testimony_btns.press_array)


func _on_Show_Present_Dialog():
	aa_testimony_btns.visible = false
	evidence.visible = true
	evidence.connect("evidence_ready_to_present", self, "_on_Evidence_Ready_To_Present")

func _on_Evidence_Ready_To_Present():
	pass

func _on_Press_Finished():
	toggle_btn_visibility()
	
	aa_button.disconnect("end_reached", self, "_on_Press_Finished")
	# process the next statement
	aa_testimony_btns.increment_current_index()
	aa_testimony_btns.process_command()
	
	
	
