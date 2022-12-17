extends Node


export(NodePath) var statement_indicator_path


onready var statement_indicator = get_node(statement_indicator_path)

var statement_scene = preload("res://AAI Case/Statement.tscn")


# The child index we're at for testimony statement
var current_index = 0


func add_statement(press_convo: Array = [], present_correct: Array = [], is_visible: bool = true):
	var statement = statement_scene.instance()
	statement.press_convo = press_convo
	statement.present_correct = present_correct
	statement.is_visible = is_visible
	add_child(statement)
	update_statement_indicator()


func remove_statement():
	#I dunno remove I guess
	update_statement_indicator()
	pass


func update_statement_indicator():
	for indicator in statement_indicator.get_children():
		indicator.set_visible(false)

	for child in get_children():
		statement_indicator.set_visible(child.is_visible)


func set_statement(idx):
	current_index = idx
	statement_indicator.select_index(current_index)
