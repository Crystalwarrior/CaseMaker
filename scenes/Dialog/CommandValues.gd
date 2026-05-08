@tool
extends Node

var cmdv:CmdValues

func instance() -> CmdValues:
	if(cmdv == null):
		cmdv = CmdValues.new()
	return cmdv

func pause_for(time_sec:float = 0.2):
	return get_tree().create_timer(time_sec).timeout
