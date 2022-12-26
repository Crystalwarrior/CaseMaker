class_name TestimonyCommand

signal testimony_over()

# puppet the testimony processor using statement index
var _statement_index
var _testimony_processor
var _press_statements # array of command processors
var _music
var _command_type


func _init(testimony_processor, press_statements, music):
	_testimony_processor = testimony_processor
	_press_statements = press_statements
	_statement_index = 0
	_music = music
	_command_type = Commands.CommandType.TESTIMONY


func start_testimony():
	var dialog = _testimony_processor.top_screen_node.dialog
	dialog.set_left_arrow_visible(false)
	
	var bottom = _testimony_processor.bottom_screen_node
	bottom.set_testimony_buttons_visible()
	
	var t_buttons = bottom.testimony_buttons
	t_buttons.connect("left_button_press", self, "move_left")
	t_buttons.connect("right_button_press", self, "move_right")
	t_buttons.connect("press", self, "press")
	t_buttons.connect("present", self, "present")
	
	var music = _testimony_processor.top_screen_node.music
	music.stream = load(_music)
	music.play()
	_testimony_processor.on_command_request()
	

func move_left():
	_statement_index -= 1
	
	# no looping, you have to go forwards
	if(_statement_index < 0):
		_statement_index = 0
	
	var dialog = _testimony_processor.top_screen_node.dialog
	dialog.set_right_arrow_visible(true)
	
	if(_statement_index == 0):
		dialog.set_left_arrow_visible(false)
	
	_testimony_processor.command_index = _statement_index
	_testimony_processor.on_command_request()
	
	
func move_right():
	_statement_index += 1
	
	# no looping, you have to go backwards
	if(_statement_index >= _testimony_processor.commands.size()):
		_statement_index = _testimony_processor.commands.size() - 1
		
	var dialog = _testimony_processor.top_screen_node.dialog
	
	dialog.set_left_arrow_visible(true)
	
	if(_statement_index == _testimony_processor.commands.size() - 1):
		dialog.set_right_arrow_visible(false)
		
	_testimony_processor.command_index = _statement_index
	_testimony_processor.on_command_request()


func press():
	if(_statement_index == _press_statements.size()):
		_statement_index = _press_statements.size() - 1
	
	var bottom = _testimony_processor.bottom_screen_node
	var press_processor = _press_statements[_statement_index]
	
	bottom.set_main_button_visible()
	bottom.main_button.connect("request_command", press_processor, "on_command_request")
	press_processor.on_command_request()
	yield(press_processor, "no_more_commands")
	press_processor.command_index = 0
	bottom.main_button.disconnect("request_command", press_processor, "on_command_request")
	bottom.set_testimony_buttons_visible()
	
	move_right() # always try to go right after pressing

func present():
	pass






func disconnect_buttons():
	var bottom = _testimony_processor.bottom_screen_node
	var t_buttons = bottom.testimony_buttons
	t_buttons.disconnect("left_button_press", self, "move_left")
	t_buttons.disconnect("right_button_press", self, "move_right")
	t_buttons.disconnect("press", self, "press")
	t_buttons.disconnect("present", self, "present")
