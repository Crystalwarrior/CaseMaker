extends Node


export(NodePath) var statement_indicator_path


onready var statement_indicators = get_node(statement_indicator_path)

var statement_scene = preload("res://AAI Case/Statement.tscn")

# The child index we're at for testimony statement
var current_index = 0


func add_statement(press_convo: Array = [], present_correct: Array = [], is_visible: bool = true):
	var statement = statement_scene.instance()
	statement.press_convo = press_convo
	statement.present_correct = present_correct
	statement.is_visible = is_visible
	add_child(statement)
	

func remove_statement(statement_index: int):
	# make the statement indicator invisible
	update_statement_indicator_visibility(statement_index, false)
	
	# remove the child from this parents children at the statement index
	self.get_children()[statement_index].is_visible = false


# update the indicator visibility at the selected index
func update_statement_indicator_visibility(index: int, visible: bool):
	var statement = get_children()[index]
	statement_indicators.indicator_set_visible(index, statement.is_visible)


func set_statement(idx):
	current_index = idx
	statement_indicators.select_index(current_index)
