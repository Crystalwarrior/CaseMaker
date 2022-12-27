extends Control

signal closeup_left()
signal closeup_right()

# basic description display
var ev_img
var ev_name
var ev_desc1
var ev_desc2

# Called when the node enters the scene tree for the first time.
func _ready():
	ev_img = get_node("%EvidenceImage")
	ev_name = get_node("%EvName")
	ev_desc1 = get_node("%EvDesc1")
	ev_desc2 = get_node("%EvDesc2")

func set_evidence(ev_object):
	ev_img.texture = load(ev_object.ev_image)
	ev_name.bbcode_text = "[center]" + ev_object.ev_name + "[/center]"
	ev_desc1.text = ev_object.ev_desc_mini
	ev_desc2.text = ev_object.ev_desc_main


func _on_Ev_Left_pressed():
	emit_signal("closeup_left")


func _on_Ev_Right_pressed():
	emit_signal("closeup_right")
