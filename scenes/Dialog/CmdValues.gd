class_name CmdValues

signal spd(to:String)
signal spd_fast()
signal spd_normal()
signal spd_slow()
signal spd_typewriter()

signal eff_flash()
signal eff_shake()
signal eff_pause(pause_amount:String)

signal new_emote(emote:String)

signal sound_music(song)
signal sound_sfx(effect)

signal adv_mode()
signal nov_mode()

signal blip(sound:String)

# text speed
const FAST = "fast"
const NORMAL = "normal"
const SLOW = "slow"
const TYPEWRITER = "typewriter"

var SPD = "spd"
var SPD_SLOW = SPD + "_" + SLOW
var SPD_NORM = SPD + "_" + NORMAL
var SPD_FAST = SPD + "_" + FAST
var SPD_TYPE = SPD + "_" + TYPEWRITER

# effects
const FLASH = "f"
const SHAKE = "s"
const PAUSE = "p"

# emotes
const EMOTE = "e"

# sounds
const MUSIC = "m"
const SFX = "sfx"

# funny testing
const ADV = "adv"
const NOV = "nov"

const BLIP = "blip"

var signal_dict:Dictionary = {
	FLASH : eff_flash,
	SHAKE : eff_shake,
	PAUSE : eff_pause,
	EMOTE : new_emote,
	MUSIC : sound_music,
	SFX : sound_sfx,
	SPD : spd,
	SPD_SLOW : spd_slow,
	SPD_NORM : spd_normal,
	SPD_FAST : spd_fast,
	SPD_TYPE : spd_typewriter,
	ADV : adv_mode,
	NOV : nov_mode,
	BLIP : blip
}

func handle_effect(cmd:String, param:String = ""):
	var cmd_signal = signal_dict[cmd]
	if(param == ""):
		cmd_signal.emit()
	else:
		cmd_signal.emit(param)
