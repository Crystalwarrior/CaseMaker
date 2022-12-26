extends HBoxContainer


export(StyleBox) var stylebox_selected
export(StyleBox) var stylebox_unselected


func _ready():
	select_index(3)


func select_index(idx):
	for child in get_children():
		child.remove_stylebox_override("panel")
		if child.get_index() == idx:
			child.add_stylebox_override("panel", stylebox_selected)
		else:
			child.add_stylebox_override("panel", stylebox_unselected)


func indicator_set_visible(idx, tog):
	get_child(idx).set_visible(tog)
