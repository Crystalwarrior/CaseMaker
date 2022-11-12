extends Control

signal text_displayed()

var dialog
var name_tag
var blip_player

# string with no (a)'s or (b)'s attached to it
var current_emote

const TXT_SPD = 0.04
const BLIP_RATE = 2

func _ready():
	dialog = $Dialog
	name_tag = $Dialog/ShownamePanel/Label
	blip_player = $Dialog/BlipPlayer
	dialog.text_speed = TXT_SPD
	blip_player.set_blip_rate(BLIP_RATE)
	blip_player.set_blip_samples([load("res://res/Sounds/blipmale.wav")])

func change_character(character_name):
	if(name_tag.text != character_name):
		if(character_name.length() < 1):
			name_tag.visible = false
		else:
			if(!name_tag.visible):
				name_tag.visible = true
				
			name_tag.text = character_name

func display_text(text:String):
	dialog.set_text(text)
	dialog.display_text()

func _on_Dialog_text_displayed():
	emit_signal("text_displayed")
