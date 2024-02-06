extends Node

var evidence_list: Array[Evidence] = []
var profiles_list: Array[Evidence] = []

func _ready():
	evidence_list.append(Evidence.new())
	evidence_list.append(Evidence.new())
	evidence_list.append(Evidence.new())
