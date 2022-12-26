extends Control

signal text_displayed()

var male_blips = preload("res://AAI Case/sfx/blips/aai_male.wav")
var female_blips = preload("res://AAI Case/sfx/blips/aai_female.wav")

onready var dialog = $Dialog
onready var nametag = $Dialog/ShownamePanel/Label
onready var nametag_label = $Dialog/ShownamePanel
onready var blip_player = $Dialog/BlipPlayer

const TXT_SPD = 0.04
const BLIP_RATE = 2

func _ready():
	# default values on initialization
	dialog.text_speed = TXT_SPD
	blip_player.set_blip_rate(BLIP_RATE)
	blip_player.set_blip_samples([male_blips])

# change nametag of character speaking
func change_nametag(nametag_text: String):
	if(nametag_text.length() == 0):
		self.nametag_label.visible = false
	else:
		if(!self.nametag_label.visible):
			self.nametag_label.visible = true
			
		self.nametag.text = nametag_text

func set_right_arrow_visible(visibility: bool):
	if(dialog.next_indicator.visible != visibility):
		dialog.next_indicator.visible = visibility

func set_left_arrow_visible(visibility: bool):
	if(dialog.next_indicator_left.visible != visibility):
		dialog.next_indicator_left.visible = visibility

func display_text(text):
	if(!self.visible):
		self.visible = true
	
	dialog.set_text(text)
	dialog.display_text()

func _on_Dialog_text_displayed():
	emit_signal("text_displayed")
