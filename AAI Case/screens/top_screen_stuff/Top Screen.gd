extends Control

signal anim_finished()

export(Texture) var background_texture

var dialog
var background
var mini_characters
var popups
var timer
var music
var sfx

func _ready():
	mini_characters = $MiniCharacters
	background = $Background/BackgroundImage
	dialog = $Dialog/AAIDialogBox
	timer = $Timer
	music = $AudioStreamPlayer
	sfx = $SFXPlayer
	background.texture = background_texture
	popups = $Popups/Bubble

# change the X offset
func set_bg_offset(offset: int):
	# offset must be negative
	if(offset > 0):
		offset *= -1
		
	background.rect_position.x = offset

# add a new character to the scene
# this should be called on initialization
func add_mini_character(character: PackedScene, pos_x: float, pos_y: float):
	var char_instance = character.instance()
	char_instance.position.x = pos_x
	char_instance.position.y = pos_y
	mini_characters.add_child(char_instance)

# hide mini_characters if need be, should be used for hiding minis
func hide_mini_characters_in_seen():
	var children = mini_characters.get_children()
	for child in children:
		child.fade_out()

# reveal mini_characters if hidden
func reveal_hidden_mini_characters():
	var children = mini_characters.get_children()
	for child in children:
		if(!child.visible):
			child.fade_in()

# place instanced big character scene into the characters list
func add_big_character(character: Node, pos_x: float = 0, pos_y: float = 0):
	character.position.x = pos_x
	character.position.y = pos_y
	background.add_child(character)

func change_bg_position(pos_x: float):
	background.rect_position.x = pos_x

func fade_in_big_character(nametag: String):
	var character = get_big_char_by_nametag(nametag)
	character.fade_in()

func fade_out_big_character(nametag: String):
	var character = get_big_char_by_nametag(nametag)
	character.fade_out()

func change_big_character_visible(nametag: String, visibility: bool):
	var character = get_big_char_by_nametag(nametag)
	character.visible = visibility

func play_pre_animation(nametag: String, pre_anim: String):
	var character = get_big_char_by_nametag(nametag)
	character.play_animation(pre_anim)
	yield(character.animation_player, "animation_finished")
	emit_signal("anim_finished")

func pan_over_bg(pos: float):
	var panning_tween = create_tween()
	panning_tween.tween_property(background, "rect_position:x", pos, 0.35)

func snap_over_bg(pos: float):
	background.rect_position.x = pos

func get_big_char_by_nametag(nametag: String):
	var character = null
	var children = background.get_children()
	for child in children:
		if(child.nametag == nametag):
			character = child
			break
	return character

func play_holdit():
	popups.hold_it()
	yield(popups, "anim_finished")
	emit_signal("anim_finished")

func play_objection():
	popups.objection()
	yield(popups, "anim_finished")
	emit_signal("anim_finished")

func play_take_that():
	popups.take_that()
	yield(popups, "anim_finished")
	emit_signal("anim_finished")
