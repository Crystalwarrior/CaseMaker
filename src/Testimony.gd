extends Node


var statements = [
#	{
#	"statement": '',
#	"press": '',
#	"present": '',
#	},
]
var index = 0

func _ready():
	pass

func next_statement():
	pass

func prev_statmenet():
	pass

func set_statement(var idx):
	index = idx

func press():
	pass

func present():
	pass

func set_statement_visible(var idx, var tog = true):
	pass

func set_press_timeline(var timeline):
	pass

func set_present_timeline(var timeline):
	pass

func new_statement():
	statements.append([
		{
			"statement": DialogTimelineResource.new(),
			"press": DialogTimelineResource.new(),
			"present": DialogTimelineResource.new(),
			"hidden": false,
		},
		{
			"statement": DialogTimelineResource.new(),
			"press": DialogTimelineResource.new(),
			"present": DialogTimelineResource.new(),
			"hidden": false,
		},
		{
			"statement": DialogTimelineResource.new(),
			"press": DialogTimelineResource.new(),
			"present": DialogTimelineResource.new(),
			"hidden": false,
		},
		{
			"statement": DialogTimelineResource.new(),
			"press": DialogTimelineResource.new(),
			"present": DialogTimelineResource.new(),
			"hidden": false,
		}
	])
	
	var statement = statements[0]
	var ev_text = DialogTextEvent.new()
	ev_text.text = "Statement 1."
	statement["statement"].events.append(ev_text)
	
	ev_text = DialogTextEvent.new()
	ev_text.text = "Press 1."
	statement["press"].events.append(ev_text)

	ev_text = DialogTextEvent.new()
	ev_text.text = "Present 1."
	statement["present"].events.append(ev_text)
