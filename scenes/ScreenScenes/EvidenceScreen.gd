extends Control

@onready var evidence_grid = %EvidenceGrid
@onready var page_label = %PageLabel
@onready var audio_player = $AudioStreamPlayer
@onready var evidence_label = %EvidenceLabel

var audio_focused: AudioStream = preload("res://assets/sounds/ui/selectblip.wav")

var page = 1


func _ready():
	connect_signals()
	load_evidence()


func _on_evidence_pressed(evi_button):
	print("fecal funny")


func _on_evidence_focused(evi_button):
	audio_player.stream = audio_focused
	audio_player.play()
	var evidence: Evidence = GameData.evidence_list[evi_button.get_index()]
	evidence_label.text = evidence.name


func connect_signals():
	for evi_button: Button in evidence_grid.get_children():
		evi_button.pressed.connect(_on_evidence_pressed.bind(evi_button))
		evi_button.focus_entered.connect(_on_evidence_focused.bind(evi_button))


func load_evidence():
	for index: int in evidence_grid.get_child_count():
		var evi_button: Button = evidence_grid.get_child(index)
		
		if index < GameData.evidence_list.size():
			var evidence: Evidence = GameData.evidence_list[index]
			evi_button.disabled = false
			evi_button.focus_mode = Control.FOCUS_ALL
			evi_button.get_node("Image").texture = evidence.image
			continue
		evi_button.disabled = true
		evi_button.focus_mode = Control.FOCUS_NONE
		evi_button.get_node("Image").texture = null
	set_page_label()


func focus_first():
	var evi = evidence_grid.get_child(0)
	evi.grab_focus()


func get_page_count() -> int:
	return ceili(float(GameData.evidence_list.size()) / float(evidence_grid.get_child_count()))


func set_page_label():
	page_label.text = "Page " + str(page) + "/" + str(get_page_count())
