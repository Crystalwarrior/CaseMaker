extends Control

@onready var dialog_box = get_node("%DialogBox")
@onready var color_fade = get_node("%ColorFade")

func create_scene_manager() -> SceneManager:
	var scene_manager = SceneManager.new(dialog_box)
	
	scene_manager.add_char(get_node("%Edgeworth"), "Edgeworth")
	
	return scene_manager

func set_chat_arrow_visible(toggle: bool = true):
	dialog_box.chat_arrow.set_visible(toggle)

func select_your_answer(toggle: bool = true):
	if toggle:
		color_fade.fade(Color(0, 0, 0, 0.5), 0.4)
	else:
		color_fade.fadein(0.1)
	dialog_box.select_answer_graphic(toggle)
