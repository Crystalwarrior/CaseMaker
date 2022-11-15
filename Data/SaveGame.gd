extends Resource

# this class should only be called from instance() in Data.gd
class_name SaveGame

# an array of dictionaries structured as follows (local to a scene):
# {
#	- index  		  : point in scene array we're in
#	- t_index		  : testimony index, leave as -1 if not in a testimony
#	- events 		  : [ series of non-dialog effects that play before dialog display ]
#	- current_speaker : the nametag of the speaker
#	- dialog 		  : dialog to be displayed - this includes flavor text/text effects
#	- displayed		  : boolean value telling us whether or not this text has been seen
# }
export(Array) var text_data = []

# the index of the current scene we're in
# scene_paths should be indexed in an array at the top level
# this index will tell us where to go on scene load (global)
export(int) var current_scene = 0

# overall evidence we collect as we go
export(Array) var evidence = []

