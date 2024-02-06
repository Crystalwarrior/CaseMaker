extends Control

@onready var evidence_grid = %EvidenceGrid
@onready var page_label = %PageLabel
@onready var audio_player = $AudioStreamPlayer
@onready var evidence_label = %EvidenceLabel
@onready var page_left_button = %PageLeft
@onready var page_right_button = %PageRight

var audio_focused: AudioStream = preload("res://assets/sounds/ui/selectblip.wav")

var evidence_list: Array[Evidence] = []
var current_page = 0

signal evidence_pressed


func _ready():
	connect_signals()
	page_left_button.pressed.connect(previous_page)
	page_right_button.pressed.connect(next_page)

	load_evidence(GameData.evidence_list)


func _on_evidence_pressed(evi_button):
	evidence_pressed.emit()


func _on_evidence_focused(evi_button):
	audio_player.stream = audio_focused
	audio_player.play()
	var evidence: Evidence = evidence_list[get_page_start_index() + evi_button.get_index()]
	evidence_label.text = evidence.name


func next_page():
	var result = wrapi(current_page + 1, 0, get_page_count())
	set_page(result)
	focus_evidence(0)


func previous_page():
	var result = wrapi(current_page -1, 0, get_page_count())
	set_page(result)
	focus_evidence(0)
	#uncomment to focus on last index on the page
	#var focus_index = get_page_end_index(current_page)
	#focus_evidence(focus_index)


func set_page(page: int):
	var old_page = current_page
	current_page = page
	if old_page != current_page:
		load_evidence()


func connect_signals():
	for evi_button: Button in evidence_grid.get_children():
		evi_button.pressed.connect(_on_evidence_pressed.bind(evi_button))
		evi_button.focus_entered.connect(_on_evidence_focused.bind(evi_button))


func add_evidence(evidence: Evidence):
	evidence_list.append(evidence)
	load_evidence()


func remove_evidence(evidence: Evidence):
	evidence_list.erase(evidence)
	load_evidence()


func load_evidence(evi_list: Array[Evidence] = evidence_list):
	evidence_list = evi_list
	var page_start_index = get_page_start_index()
	for index: int in evidence_grid.get_child_count():
		var evi_button: Button = evidence_grid.get_child(index)
		
		if index < evidence_list.size() - page_start_index:
			var evidence: Evidence = evidence_list[page_start_index + index]
			evi_button.disabled = false
			evi_button.focus_mode = Control.FOCUS_ALL
			evi_button.get_node("Image").texture = evidence.image
			continue
		evi_button.disabled = true
		evi_button.focus_mode = Control.FOCUS_NONE
		evi_button.get_node("Image").texture = null
	set_page_label()
	
	var multiple_pages: bool = get_page_count() > 1
	page_label.set_visible(multiple_pages)
	page_left_button.disable(not multiple_pages)
	page_right_button.disable(not multiple_pages)


func focus_evidence(index: int = -1):
	if index == -1:
		for evi_button: Button in evidence_grid.get_children():
			if evi_button.has_focus():
				evi_button.release_focus()
				break
		return
	if index >= evidence_grid.get_child_count():
		return
	var evi = evidence_grid.get_child(index)
	evi.grab_focus()


func get_page_start_index(page: int = current_page) -> int:
	return evidence_grid.get_child_count() * page


func get_page_end_index(page: int = current_page) -> int:
	return min(evidence_grid.get_child_count()-1, get_page_end_index(current_page)-1)


func get_page_count() -> int:
	return ceili(float(evidence_list.size()) / float(evidence_grid.get_child_count()))


func set_page_label():
	page_label.text = "Page " + str(current_page+1) + "/" + str(get_page_count())
