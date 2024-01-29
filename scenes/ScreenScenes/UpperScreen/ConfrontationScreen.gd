extends Control

@onready var dialog_box = get_node("%DialogBox")

func create_scene_manager() -> SceneManager:
	var scene_manager = SceneManager.new(dialog_box)
	
	scene_manager.add_char(get_node("%Edgeworth"), "Edgeworth")
	
	return scene_manager

func set_chat_arrow_visible(toggle: bool = true):
	dialog_box.chat_arrow.set_visible(toggle)
