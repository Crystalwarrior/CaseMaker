extends Node

var evidence_list: Array[Evidence] = []
var profiles_list: Array[Evidence] = []

func _ready():
	for i in 12:
		evidence_list.append(Evidence.new())
