extends Node

# preloaded scenes
const CW_SCENE = preload("res://AAI Case/characters/CW/CW.tscn")
const LUKE_SCENE = preload("res://AAI Case/characters/Luke/Luke.tscn")

# scene instances
var cw
var luke

# persistant instance of characters using singleton pattern
func make_CW_scene():
	if(cw == null):
		cw = CW_SCENE.instance()
		cw.nametag = "Crystalwarrior"
	
	return cw

func make_Luke_scene():
	if(luke == null):
		luke = LUKE_SCENE.instance()
		luke.nametag = "Luke"
	
	return luke

# clear up space for characters we aren't using
# in specific scenes
func unload_characters():
	# to be implemented
	pass

# we are using persistant instances, meaning that all
# changes we make in other classes affect the scenes
# stored in this one, this should reset any changes we'd make to them
func reset_all_character_properties():
	reset_character_status(cw)
	reset_character_status(luke)

func reset_character_status(character):
	character.reset_character_properties()
	
