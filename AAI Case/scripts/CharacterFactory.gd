extends Node

const CW_NAMETAG = "Crystalwarrior"
const LUKE_NAMETAG = "Luke"

# preloaded scenes
const CW_SCENE = preload("res://AAI Case/characters/CW/CW.tscn")
const LUKE_SCENE = preload("res://AAI Case/characters/Luke/Luke.tscn")

const CW_MINI = preload("res://AAI Case/characters/CW/CWMini.tscn")
const LUKE_MINI = preload("res://AAI Case/characters/Luke/LukeMini.tscn")
	
func make_cw(fadeout: bool = false, emote: String = "normal"):
	var cw = CharacterFactory.CW_SCENE.instance()
	cw.nametag = CharacterFactory.CW_NAMETAG
	cw.init_fade = fadeout
	cw.init_emote = emote
	
	return cw

func make_luke(fadeout: bool = false, emote: String = "normal"):
	var luke = CharacterFactory.LUKE_SCENE.instance()
	luke.nametag = CharacterFactory.LUKE_NAMETAG
	luke.init_fade = fadeout
	luke.init_emote = emote
	
	return luke
