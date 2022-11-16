extends Control

signal text_displayed()

var dialog
var name_tag
var blip_player

const TXT_SPD = 0.035
const BLIP_RATE = 0.0785
# const BLIP_RATE = 0.075

var speaking_char_scene

func _ready():
	dialog = $Dialog
	name_tag = $Dialog/ShownamePanel/Label
	blip_player = $Dialog/BlipPlayer
	dialog.text_speed = TXT_SPD
	blip_player._blip_rate = BLIP_RATE
	blip_player.set_blip_samples([load("res://AAI Case/sfx/aai_male.wav")])

func change_character(character_scene):
	var character_name = ""
	
	if(character_scene != null):
		character_name = character_scene.nametag
		
		if(!name_tag.visible):
			name_tag.visible = true
		
		name_tag.text = character_name
		speaking_char_scene = character_scene
		
	else:
		name_tag.visible = false
		speaking_char_scene = null
		
		
func display_text(text, emote):
	if(speaking_char_scene != null):
		speaking_char_scene.make_character_talk(emote)
	
	dialog.set_text(text)
	dialog.display_text()
	yield(self, "text_displayed")
	
	if(speaking_char_scene != null):
		speaking_char_scene.make_character_idle(emote)

func _on_Dialog_text_displayed():
	emit_signal("text_displayed")
