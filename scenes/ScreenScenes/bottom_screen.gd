extends Control

@onready var next_button = %NextButton
@onready var animation_player = $AnimationPlayer
@onready var choice_container = %ChoiceContainer
@onready var evidence_screen = %EvidenceScreen

signal choice_selected(index)

func _ready():
	%CourtRecordButton.pressed.connect(_on_court_record_button_pressed)
	%ToProfilesButton.pressed.connect(_on_profiles_button_pressed)
	%ToEvidenceButton.pressed.connect(_on_evidence_button_pressed)
	%BackButton.pressed.connect(_on_back_button_pressed)
	evidence_screen.evidence_pressed.connect(_on_evidence_pressed)
	choice_container.choice_selected.connect(_on_choice_selected)


func _on_court_record_button_pressed():
	animation_player.play("court_record_pressed")


func _on_profiles_button_pressed():
	animation_player.play("to_profiles")
	evidence_screen.focus_evidence(evidence_screen.current_evidence_index)


func _on_evidence_button_pressed():
	animation_player.play("to_evidence")
	evidence_screen.focus_evidence(evidence_screen.current_evidence_index)


func _on_back_button_pressed():
	if evidence_screen.zoomed_in:
		evidence_screen.zoom_evidence(false)
		%BackButton.button_pressed = false
	else:
		animation_player.play("back_pressed")


func _on_evidence_pressed():
	evidence_screen.zoom_evidence(true)


func _on_choice_selected(index):
	animation_player.play("choice_given")
	await animation_player.animation_finished
	choice_selected.emit(index)


func multiple_choice(choices: PackedStringArray):
	choice_container.populate_choices(choices)
	animation_player.play("to_choices")

func clear_choices():
	choice_container.clear_choices()
