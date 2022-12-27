extends Control

signal back_pressed()
signal present_request(evidence)

onready var present = $PresentButton
onready var back = $BackButton

var hub
var closeup
var evidence

func _ready():
	hub = $EvidenceMenuHub
	closeup = $EvidenceCloseup
	
	hub.connect("show_closeup", self, "on_show_closeup")


func load_evidence():
	evidence = PersistentObjects.evidence_holder
	hub.set_page_one_of_evidence()


func present_enabled(enabled: bool):
	present.disabled = !enabled
	if(!enabled):
		present.text = ""
	else:
		present.text = "Present"


func on_show_closeup(evidence_object):
	evidence.set_closeup_index(evidence_object)
	closeup.set_evidence(evidence_object)
	
	if(!closeup.visible):
		hub.visible = false
		closeup.visible = true


func _on_BackButton_pressed():
	if(closeup.visible):
		closeup.visible = false
		hub.visible = true
	else:
		hub.selected = null
		emit_signal("back_pressed")


func _on_EvidenceCloseup_closeup_left():
	evidence.closeup_index -= 1
	
	if(evidence.closeup_index < 0):
		evidence.closeup_index = 0
	
	set_closeup_object()


func _on_EvidenceCloseup_closeup_right():
	evidence.closeup_index += 1
	
	if(evidence.closeup_index >= evidence.all_evidence.size()):
		evidence.closeup_index = evidence.all_evidence.size() - 1
	
	set_closeup_object()


func set_closeup_object():
	var evidence_object = evidence.get_evidence_at_closeup_index()
	hub.selected = evidence_object
	on_show_closeup(evidence_object)
	
	
func _on_PresentButton_pressed():
	if(hub.selected != null):
		emit_signal("present_request", hub.selected)
