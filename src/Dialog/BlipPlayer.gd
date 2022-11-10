extends AudioStreamPlayer

enum BlipStrategy {NO_BLIP, BLIP_ONCE, BLIP_LOOP}

var _blip_samples:Array = [] setget set_blip_samples
var _blip_space_samples:Array = [] setget set_blip_space_samples
var _blip_strategy:int = BlipStrategy.BLIP_LOOP setget set_blip_strategy
var _blip_rate:int = 2 setget set_blip_rate
var _blip_force:bool = true setget force_blip
var _blip_map:bool = false setget map_blip_to_letter
var _blip_bus:String = "Master" setget set_audio_bus

var _blip_counter:int = 0
var _already_played:bool = false

var _generator = RandomNumberGenerator.new()


func reset():
	_blip_counter = 0
	_already_played = false


func _on_character_displayed(character:String) -> void:
	var _blip_sample:AudioStream

	match _blip_strategy:
		BlipStrategy.BLIP_LOOP:
			
			if _blip_counter % _blip_rate == 0:
				if character in " " or character.strip_escapes().empty():
					_blip_sample = get_space_blip_sample()
					_blip(_blip_sample)
					_blip_counter = 0
					return
				
				_blip_sample = get_blip_sample(character)
				
				if not self.is_playing() or _blip_force:
					_blip(_blip_sample)
			
			_blip_counter += 1
				
			
		BlipStrategy.BLIP_ONCE:
			if _already_played:
				return
			_blip_sample = get_blip_sample()
			_blip(_blip_sample)
			_already_played = true


func _blip(with_sound:AudioStream) -> void:
	var _stream:AudioStream = with_sound
	
	if _stream == null:
		return
	
	self.bus = _blip_bus
	self.stream = _stream
	self.play()


func set_blip_strategy(strategy:int) -> void:
	_blip_strategy = clamp(strategy, 0, BlipStrategy.size()-1)


## Set the blip samples that'll be used on blip
func set_blip_samples(samples:Array) -> void:
	_blip_samples = samples.duplicate()


func set_blip_space_samples(samples:Array) -> void:
	_blip_space_samples = samples.duplicate()


func set_audio_bus(bus:String) -> void:
	_blip_bus = bus


func set_blip_rate(value:int) -> void:
	_blip_rate = max(1, value)


func force_blip(value:bool) -> void:
	_blip_force = value


func map_blip_to_letter(value:bool) -> void:
	_blip_map = value


func get_blip_sample(for_char:String="") -> AudioStream:
	var blip_sample:AudioStream
	if _blip_samples.empty():
		return null
	
	if _blip_map:
		
		pass
	var _limit = max(_blip_samples.size()-1, 0)
	blip_sample = _blip_samples[_generator.randi_range(0, _limit)] as AudioStream
	return blip_sample


func get_space_blip_sample() -> AudioStream:
	var blip_sample:AudioStream
	
	if _blip_space_samples.empty():
		return null
	
	var _limit = max(_blip_samples.size()-1, 0)
	blip_sample = _blip_space_samples[_generator.randi_range(0, _limit)] as AudioStream
	
	return blip_sample
