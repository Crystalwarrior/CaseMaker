extends Control

@onready var dialog_box = get_node("%DialogBox")
@onready var foreground_fade = get_node("%ForegroundFade")
@onready var character_container = get_node("%CharacterContainer")
@onready var background = get_node("%Background")
@onready var viewport = get_node("%SubViewport")

func create_scene_manager() -> SceneManager:
	var scene_manager = SceneManager.new(dialog_box)

	for character in character_container.get_children():
		scene_manager.add_char(character, character.name)

	return scene_manager

func set_chat_arrow_visible(toggle: bool = true):
	dialog_box.chat_arrow.set_visible(toggle)

func select_your_answer(toggle: bool = true):
	if toggle:
		foreground_fade.fade(Color(0, 0, 0, 0.5), 0.4)
	else:
		foreground_fade.fadein(0.1)
	dialog_box.select_answer_graphic(toggle)

func change_background(background_res):
	background.change_to(background_res)
