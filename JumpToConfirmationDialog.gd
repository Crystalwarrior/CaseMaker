extends ConfirmationDialog

@onready var line_edit: LineEdit = %IndexLineEdit

signal jump_to(text)


func _on_index_line_edit_text_submitted(new_text):
	_on_confirmed()


func _on_confirmed():
	if line_edit.text != "":
		jump_to.emit(line_edit.text)
	hide()
