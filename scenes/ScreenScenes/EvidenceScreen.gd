extends Control

@onready var evidence_grid = %EvidenceGrid
@onready var page_label = %PageLabel
@onready var audio_player = $AudioStreamPlayer
@onready var evidence_label = %EvidenceLabel
@onready var page_left_button = %PageLeft
@onready var page_right_button = %PageRight
@onready var animation_player = %AnimationPlayer
@onready var evidence_desc_label = $EvidenceDescLabel
@onready var evidence_short_desc_label = $EvidenceShortDescLabel
@onready var evidence_icon = %EvidenceIcon

var audio_focused: AudioStream = preload("res://assets/sounds/ui/selectblip.wav")
var audio_zoom_in: AudioStream = preload("res://assets/sounds/ui/bleep.wav")
var audio_zoom_out: AudioStream = preload("res://assets/sounds/ui/cancel.wav")
var audio_swipe: AudioStream = preload("res://assets/sounds/ui/blink.wav")

var evidence_list: Array[Evidence] = []
var current_page = 0
var current_evidence_index = -1

var zoomed_in: bool = false

signal evidence_pressed


func _ready():
	connect_signals()
	page_left_button.pressed.connect(previous_page)
	page_right_button.pressed.connect(next_page)


func _on_evidence_pressed(evi_button):
	evidence_pressed.emit()


func _on_evidence_focused(evi_button):
	if not audio_player.playing or audio_player.stream == audio_focused:
		audio_player.stream = audio_focused
		audio_player.play()
	var evidence_index = get_page_start_index() + evi_button.get_index()
	current_evidence_index = evidence_index
	var evidence: Evidence = evidence_list[evidence_index]
	evidence_label.text = evidence.name
	evidence_desc_label.text = evidence.long_desc
	evidence_short_desc_label.text = evidence.short_desc
	evidence_icon.texture = evidence.image


func next_page():
	audio_player.stream = audio_swipe
	audio_player.play()
	if zoomed_in:
		var result = wrapi(current_evidence_index + 1, 0, evidence_list.size())
		focus_evidence(result)
		return
	var result = wrapi(current_page + 1, 0, get_page_count())
	set_page(result)
	evidence_grid.get_child(0).grab_focus()


func previous_page():
	audio_player.stream = audio_swipe
	audio_player.play()
	if zoomed_in:
		var result = wrapi(current_evidence_index - 1, 0, evidence_list.size())
		focus_evidence(result)
		return
	var result = wrapi(current_page - 1, 0, get_page_count())
	set_page(result)
	evidence_grid.get_child(0).grab_focus()


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
	check_page_buttons()


func focus_evidence(index: int = -1):
	if index == -1:
		for evi_button: Button in evidence_grid.get_children():
			if evi_button.has_focus():
				evi_button.release_focus()
				break
		current_evidence_index = -1
		return
	while index < get_page_start_index():
		var result = wrapi(current_page - 1, 0, get_page_count())
		set_page(result)
	index = index - get_page_start_index()
	while index > get_page_end_index():
		var result = wrapi(current_page + 1, 0, get_page_count())
		set_page(result)
		index = index - get_page_start_index()
	if index >= evidence_grid.get_child_count():
		return
	var evi = evidence_grid.get_child(index)
	evi.grab_focus()
	set_page_label()


func check_page_buttons():
	var multiple_pages: bool = get_page_count() > 1
	if zoomed_in:
		page_label.set_visible(evidence_list.size() > 1)
		page_left_button.disable(evidence_list.size() <= 1)
		page_right_button.disable(evidence_list.size() <= 1)
	else:
		page_label.set_visible(multiple_pages)
		page_left_button.disable(not multiple_pages)
		page_right_button.disable(not multiple_pages)
	set_page_label()


func zoom_evidence(zoom: bool = true):
	if zoom:
		animation_player.play("evidence_clicked")
		audio_player.stream = audio_zoom_in
		audio_player.play()
	else:
		animation_player.play_backwards("evidence_clicked")
		audio_player.stream = audio_zoom_out
		audio_player.play()
	zoomed_in = zoom
	check_page_buttons()


func get_page_start_index(page: int = current_page) -> int:
	return evidence_grid.get_child_count() * page


func get_page_end_index(page: int = current_page) -> int:
	return min(evidence_grid.get_child_count() - 1, evidence_list.size() - get_page_start_index(current_page) - 1)

	
func get_page_count() -> int:
	return ceili(float(evidence_list.size()) / float(evidence_grid.get_child_count()))


func set_page_label():
	if zoomed_in:
		var num = current_evidence_index+1
		num = " " + str(num) if num < 10 else str(num)
		page_label.text = "Entry " + num + "/" + str(evidence_list.size())
	else:
		var num = current_page+1
		num = " " + str(num) if num < 10 else str(num)
		page_label.text = "Page " + num + "/" + str(get_page_count())
