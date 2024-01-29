extends Control

@onready var next_button = %NextButton
@onready var animation_player = $AnimationPlayer

func _ready():
	%CourtRecordButton.pressed.connect(_on_court_record_button_pressed)
	%EvidenceButton.pressed.connect(_on_evidence_button_pressed)
	%ProfilesButton.pressed.connect(_on_profiles_button_pressed)
	%BackButton.pressed.connect(_on_back_button_pressed)


func _on_court_record_button_pressed():
	animation_player.play("court_record_pressed")


func _on_evidence_button_pressed():
	animation_player.play("to_profiles")


func _on_profiles_button_pressed():
	animation_player.play("to_evidence")


func _on_back_button_pressed():
	animation_player.play("back_pressed")
