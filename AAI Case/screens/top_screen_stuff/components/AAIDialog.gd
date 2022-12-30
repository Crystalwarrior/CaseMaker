extends Control

signal text_displayed()

var male_blips = preload("res://AAI Case/sfx/blips/aai_male.wav")
var female_blips = preload("res://AAI Case/sfx/blips/aai_female.wav")

onready var dialog = $Dialog
onready var nametag = $Dialog/ShownamePanel/Label
onready var nametag_label = $Dialog/ShownamePanel
onready var blip_player = $Dialog/BlipPlayer


var _lvis
var _rvis

func _ready():
	blip_player.blip_sound = male_blips

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

func toggle_arrows_visible(visibility: bool):
	if(!visibility):
		_lvis = dialog.next_indicator.visible
		_rvis = dialog.next_indicator_left.visible
		
		dialog.next_indicator.visible = false
		dialog.next_indicator_left.visible = false
	
	else:
		dialog.next_indicator.visible = _lvis
		dialog.next_indicator_left.visible = _rvis
		

func display_text(text):
	if(!self.visible):
		self.visible = true
	
	dialog.set_text(text)
	dialog.display_text()

func display_add_text(text):
	if(!self.visible):
		self.visible = true
	
	dialog.add_text(text)
	dialog.display_text()

func _on_Dialog_text_displayed():
	emit_signal("text_displayed")
