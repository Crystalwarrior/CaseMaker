extends Node2D

onready var blip_player = $HUD/Dialog/BlipPlayer
onready var show_name = $HUD/Dialog/ShownamePanel/Label
onready var dialog = $HUD/Dialog

const text_speed_base = 0.02

# character we're currently working with
var current_char
# animation to play after text is done
var post_anim = ""

func _on_ButtonTest_pressed():
	# Reset the background to be visible, hide the zoom
	$World/Background.set_visible(true)
	$World/def_speedlines.set_visible(false)

	# Set the music
	$MusicPlayer.play_music(load("res://res/Music/1-03 Gyakuten Saiban - Trial.ogg"))
	
	# Set up the blip sample to male and reset the text speed
	blip_player.set_blip_samples([load("res://res/Sounds/blipmale.wav")])
	dialog.text_speed = text_speed_base
	# Any blip rate slower than the base text speed should be set to 2. Otherwise, set blip rate to 3.
	blip_player.set_blip_rate(3)
	# Set the displayed background
	$World/CameraAnimPlayer.play("def")
	show_name.text = "Phoenix"
	# Set current character so the game knows who to play animations on
	current_char = $World/Characters/Phoenix/AnimationPlayer
	
	# Display two-parter text with changing animations and damage sound
	dialog.set_visible(true)
	dialog.set_text("I am doing your mom")
	dialog.display_text()
	post_anim = "normal(a)"
	current_char.play("normal(b)")
	yield(get_tree().create_timer(1.25), "timeout")
	post_anim = "confident(a)"
	current_char.play("confident(b)")
	$SFXPlayer.set_stream(load("res://res/Sounds/damage1.wav"))
	$SFXPlayer.play()
	dialog.add_text(" AND dad!")
	dialog.display_text()
	
	# Hide dialog box, slam the desk, make Phoenix talk with his hands still on desk, screenflash
	yield(get_tree().create_timer(1.25), "timeout")
	dialog.set_visible(false)
	current_char.play("deskslam")
	yield(get_tree().create_timer(0.2), "timeout")
	# Screenshake
	$World/Camera2D.add_trauma(0.4)
	yield(get_tree().create_timer(1.25), "timeout")
	post_anim = "handsondesk(a)"
	current_char.play("handsondesk(b)")
	
	# Play the screenflash animation and sound effect
	$SFXPlayer.set_stream(load("res://res/Sounds/realization.wav"))
	$SFXPlayer.play()
	$ScreenAnimPlayer.play("flash")
	dialog.set_visible(true)
	dialog.set_text("WHAT the [color=lime]fuck[/color] do you MEAN!?")
	dialog.display_text()
	
	# Screen Panning Test
	yield(get_tree().create_timer(1.5), "timeout")
	$World/CameraAnimPlayer.play("def_to_pro")
	dialog.display_text()
	dialog.set_text("[shake]WOAAAAAAAHHHHHHHHHH[/shake]")
	yield(get_tree().create_timer(1.25), "timeout")
	$World/CameraAnimPlayer.play("pro_to_def")
	dialog.display_text()
	dialog.set_text("Back to me baby")
	yield(get_tree().create_timer(1.25), "timeout")
	
	# Objection bubble
	$SFXPlayer.set_stream(load("res://res/Sounds/objection.wav"))
	$SFXPlayer.play()
	$HUD/Bubble/AnimationPlayer.play("objection")
	
	# Stop music
	$MusicPlayer.stop_music(1)
	
	yield(get_tree().create_timer(0.7), "timeout")
	
	# Swap pos to judge, make judge fart
	$World/CameraAnimPlayer.play("jud")
	current_char = $World/Characters/Judge/AnimationPlayer
	post_anim = "judge-normal(a)"
	current_char.play("judge-normal(b)")
	show_name.text = "Judge"
	dialog.set_text("I [color=#FF773D]farted[/color], [wave]lmao!![/wave]")
	dialog.display_text()
	
	yield(get_tree().create_timer(1.25), "timeout")

	# Phoenix Objection
	$SFXPlayer.set_stream(load("res://res/Sounds/Voice/Phoenix - objection.wav"))
	$SFXPlayer.play()
	$HUD/Bubble/AnimationPlayer.play("objection")
	yield(get_tree().create_timer(0.7), "timeout")

	dialog.set_visible(false)
	# Set the displayed background
	$World/CameraAnimPlayer.play("def")
	show_name.text = "Phoenix"
	# Set current character so the game knows who to play animations on
	current_char = $World/Characters/Phoenix/AnimationPlayer
	current_char.play("pointing(a)")
	yield(get_tree().create_timer(1.0), "timeout")
	
	current_char.play("document(b)")
	post_anim = "document(a)"
	dialog.set_visible(true)
	dialog.set_text("Your honor, this paper proves a very large contradiction.")
	dialog.display_text()

	yield(get_tree().create_timer(2.6), "timeout")

	# Phoenix face zoom!!
	$World/Background.set_visible(false)
	$World/def_speedlines.set_visible(true)
	# Play objection sound
	$SFXPlayer.set_stream(load("res://res/Sounds/objection.wav"))
	$SFXPlayer.play()
	# Screenshake
	$World/Camera2D.add_trauma(0.4)
	current_char.play("zoom(b)")
	post_anim = "zoom(a)"
	dialog.set_text("You [color=#FF773D]can't physically fart[/color]!")
	dialog.display_text()
	
	$MusicPlayer.play_music(load("res://res/Music/1-06 Ryuichi Naruhodo _ Objection! 2001.ogg"))

	# TODO: Display new text with "Next" button

func _on_Dialog_text_displayed():
	current_char.play(post_anim)
