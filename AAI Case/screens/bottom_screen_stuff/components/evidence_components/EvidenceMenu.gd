extends Control

signal show_closeup(evidence_object)

var evidence_holder

# the selected evidence (for presenting)
var selected = null

onready var label = $EvidenceNamePanel/EvidenceNameLabel
onready var ev1 = $MenuHub/UpperRow/Evidence1
onready var ev2 = $MenuHub/UpperRow/Evidence2
onready var ev3 = $MenuHub/UpperRow/Evidence3
onready var ev4 = $MenuHub/UpperRow/Evidence4
onready var ev5 = $MenuHub/LowerRow/Evidence5
onready var ev6 = $MenuHub/LowerRow/Evidence6
onready var ev7 = $MenuHub/LowerRow/Evidence7
onready var ev8 = $MenuHub/LowerRow/Evidence8

onready var evidence_pics = [ ev1, ev2, ev3, ev4, ev5, ev6, ev7, ev8 ]

# input = EvidenceHolder
func set_page_one_of_evidence():
	evidence_holder = PersistentObjects.evidence_holder
	evidence_holder.page_index = 0
	populate_evidence_page()


func populate_evidence_page():
	var evidence_page = evidence_holder.get_evidence_at_current_index()
	
	var page_size = evidence_page.size()
	
	for i in range(page_size):
		evidence_pics[i].texture_normal = load(evidence_page[i].ev_image)
		evidence_pics[i].texture_normal.resource_local_to_scene = true
		
		var panels = evidence_pics[i].get_children()
		for panel in panels:
			panel.visible = false
	
	var remaining_ev = evidence_pics.size() - page_size
	
	# hide unused frames
	for i in range(remaining_ev, evidence_pics.size()):
		evidence_pics[i].visible = false
		var panels = evidence_pics[i].get_children()
		for panel in panels:
			panel.visible = true


func _on_LeftButton_pressed():
	var old = evidence_holder.page_index
	evidence_holder.page_index -= 1
	
	if(evidence_holder.page_index < 0):
		evidence_holder.page_index = 0
	
	if(old != evidence_holder.page_index):
		populate_evidence_page()


func _on_RightButton_pressed():
	var old = evidence_holder.page_index
	evidence_holder.page_index += 1
	
	if(evidence_holder.page_index >= evidence_holder.pages.size()):
		evidence_holder.page_index = evidence_holder.pages.size() - 1
	
	if(old != evidence_holder.page_index):
		populate_evidence_page()

# -- BUTTON CLICK EVENTS --

func _on_Evidence1_pressed():
	close_up_on_index(0)

func _on_Evidence2_pressed():
	close_up_on_index(1)

func _on_Evidence3_pressed():
	close_up_on_index(2)

func _on_Evidence4_pressed():
	close_up_on_index(3)

func _on_Evidence5_pressed():
	close_up_on_index(4)

func _on_Evidence6_pressed():
	close_up_on_index(5)

func _on_Evidence7_pressed():
	close_up_on_index(6)

func _on_Evidence8_pressed():
	close_up_on_index(7)
	
func close_up_on_index(index):
	var evidence_page = evidence_holder.get_evidence_at_current_index()
	selected = evidence_page[index]
	emit_signal("show_closeup", evidence_page[index])
	
	
# -- MOUSE ENTER EVENTS --

func _on_Evidence1_mouse_entered():
	change_evidence_label(0)

func _on_Evidence2_mouse_entered():
	change_evidence_label(1)

func _on_Evidence3_mouse_entered():
	change_evidence_label(2)

func _on_Evidence4_mouse_entered():
	change_evidence_label(3)

func _on_Evidence5_mouse_entered():
	change_evidence_label(4)
	
func _on_Evidence6_mouse_entered():
	change_evidence_label(5)

func _on_Evidence7_mouse_entered():
	change_evidence_label(6)

func _on_Evidence8_mouse_entered():
	change_evidence_label(7)

func change_evidence_label(index):
	var evidence_page = evidence_holder.get_evidence_at_current_index()
	if(index <= evidence_page.size()-1):
		selected = evidence_page[index]
		label.bbcode_text = "[center]" + evidence_page[index].ev_name +"[/center]"
