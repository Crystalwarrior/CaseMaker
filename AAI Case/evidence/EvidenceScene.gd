extends Control

var evidence_id
var evidence_description

signal display_evidence_description(description)

func set_button_text(button_text):
	$Button.text = button_text

func _on_Button_pressed():
	emit_signal("display_evidence_description", evidence_id, evidence_description)
