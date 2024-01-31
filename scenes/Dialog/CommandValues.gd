@tool
extends Node

var cmdv:CmdValues

func instance() -> CmdValues:
	if(cmdv == null):
		cmdv = CmdValues.new()
	return cmdv
