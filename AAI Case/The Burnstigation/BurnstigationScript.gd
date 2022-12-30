extends Node

var scenes = [
	preload("res://AAI Case/The Burnstigation/scenes/1. Intro.tscn"),
	preload("res://AAI Case/The Burnstigation/scenes/2. Investigation 1.tscn"),
	preload("res://AAI Case/The Burnstigation/scenes/3. Testimony1.tscn")
]

var index = -1

func _ready():
	# PersistentObjects.evidence_holder = EvidenceHolder.new()
	change_scene()

func change_scene():
	index += 1
	
	var new_scene = scenes[index]
	var instanced_scene = new_scene.instance()
	
	instanced_scene.connect("scene_ended", self, "change_scene")
	
	for child in get_children():
		remove_child(child)
		
	add_child(instanced_scene)
