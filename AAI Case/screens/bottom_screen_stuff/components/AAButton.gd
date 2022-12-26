# All an AA button has to do is increment through text until it's done
extends Control

signal request_command()

onready var button = $MainButton

func _on_MainButton_pressed():
	emit_signal("request_command")

func _set_enabled(tog):
	button.set_disabled(!tog)
