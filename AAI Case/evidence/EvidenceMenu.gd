extends Control
onready var back_button = $"%BackButton"
onready var present_button = $"%Present"
onready var evidence_buttons = $"%EvidenceButtons"
onready var evidence_description = $"%EvidenceDesc"
onready var evidence_scene = "res://AAI Case/evidence/EvidenceScene.tscn"

signal evidence_ready_to_present()

# id starts at 1
var current_evidence_id = 0

# input = { "id": id, "text": "text", "desc": "desc" }
func add_evidence(evidence_dict):
	var init_evidence_scene = load(evidence_scene).instance()
	init_evidence_scene.set_button_text(evidence_dict["ev_name"])
	init_evidence_scene.evidence_id = evidence_dict["id"]
	init_evidence_scene.evidence_description = evidence_dict["desc"]
	init_evidence_scene.connect("display_evidence_description", self, "_on_Display_Evidence_Desc")
	evidence_buttons.add_child(init_evidence_scene)

func set_present_visibility(visibility):
	present_button.visibility = true

func _on_Display_Evidence_Desc(id, ev_desc_string):
	current_evidence_id = id
	evidence_description.text = ev_desc_string

func _on_Present_pressed():
	if(current_evidence_id != 0):
		emit_signal("evidence_ready_to_present")
