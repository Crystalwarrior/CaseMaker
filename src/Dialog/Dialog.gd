extends DialogDialogueManager

export(NodePath) var BlipSound_path:NodePath
export var blip_rate = 2

onready var BlipSound:AudioStreamPlayer = get_node_or_null(BlipSound_path) as AudioStreamPlayer

var blip_counter = 0

func _ready():
	self.connect("character_displayed", self, "_on_character_displayed")
	self.connect("text_displayed", self, "_on_text_displayed")

func _on_character_displayed(character):
	if character in " " or character.strip_escapes().empty():
		blip_counter = 0
		return
#	print(character, ': ', blip_counter, ' ', blip_rate, ' modulo: ', blip_counter % blip_rate)
	if blip_counter % blip_rate == 0:
		BlipSound.play()
#		print('!')
	blip_counter += 1

func _on_text_displayed():
	blip_counter = 0
