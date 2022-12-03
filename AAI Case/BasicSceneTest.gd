# Basic Scene Test is template for the basic workflow of this project
extends "res://AAI Case/scripts/SceneController.gd"

# characters
onready var CW = $ConfrontationBG/CW
onready var Luke = $ConfrontationBG/Luke
onready var background = $ConfrontationBG
onready var aa_button = $AAButton
onready var aa_testimony_btns = $TestimonyButtons
onready var evidence = $Evidence

onready var music_player = $MusicPlayer

# a variable that tracks what to do next when each scene finishes
var array_progress_tracker = 0

const TIMEOUT_VALUE = 0.8
const PAN_SPEED = 0.7

# input = { "text": "text", "desc": "desc" }
onready var evidence_dict = {
	"id" : 1,
	"ev_name" : "Your Mom Joke",
	"desc" : "Sometimes, you need something that\nwill end a debate in a nanosecond.\nThe mom joke is that debate killer.\nImpossible to lose with\nthis piece of evidence."
}

func _ready():
	dialog_box = $CanvasLayer/AAIDialogBox
	evidence.add_evidence(evidence_dict)
	
	add_character_speaking(CW, "crossed","With THIS line of dialog,\nI'll win the battle.")
	add_snap_to_pos(background, ConfrontationPositions.RIVAL)
	add_character_speaking(Luke, "normal","You cannot win this battle.\nIt's not possible.")
	add_character_speaking(Luke, "normal", "This text is far superior.")
	add_snap_to_pos(background, ConfrontationPositions.DEF)
	add_character_speaking(CW, "normal","Oh yeah? Well...")
	add_snap_to_pos(background, ConfrontationPositions.RIVAL)
	add_character_speaking(Luke, "normal", "\"Well\" nothing.\nTime for a cross-examination.")
	
	var statement1 = make_character_speaking(Luke, "normal","[color=00FF00]This is the first statement.[/color]")
	var statement2 = make_character_speaking(Luke, "normal","[color=00FF00]This is the second statement.[/color]")
	var statement3 = make_character_speaking(Luke, "normal","[color=00FF00]This is statement number 3.[/color]")
	var statement4 = make_character_speaking(Luke, "normal","[color=00FF00]This is statement number 4.[/color]")
	
	var statement1full = [
		statement1
	]
	
	var press1 = [	
		make_snap_to_pos(background, ConfrontationPositions.DEF),
		make_character_speaking(CW, "normal","Is this the first press?"),
		make_snap_to_pos(background, ConfrontationPositions.RIVAL),
		make_character_speaking(Luke, "normal","It is."),
		make_snap_to_pos(background, ConfrontationPositions.DEF),
		make_character_speaking(CW, "normal","Next statement.")
	]
	
	add_statement_to_testimony(statement1full, press1)
	
	aa_button.connect("request_command", self, "_on_Command_Request")
	
	process_first_command()


func hold_it_CW():
	$SFXPlayer.set_stream(load("res://AAI Case/sfx/cw_holdit.wav"))
	$SFXPlayer.play()
	$CanvasLayer/Bubble/AnimationPlayer.play("holdit")

# helper functions
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
			
			#aa_testimony_btns.set_command_array(testimony1)
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
	
	
	
