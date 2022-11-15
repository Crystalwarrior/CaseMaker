extends Node

var save_game: SaveGame
var save_name = "save"
var save_path = "user://%s.tres"

# return a new save_game instance if it is not loaded
func instance():
	if(save_game == null):
		save_game = SaveGame.new()
	
	return save_game

# instance() creates a new save game if null,
# it should be persistent throughout the game
func save_data():
	ResourceSaver.save(save_path % save_name, save_game.instance())

# Load data for the top level scene to process
func load_data() -> Dictionary:
	var save_file = save_path % save_name
	var game_state_dictionary = {
		"frame_data" : {},
		"evidence"	 : []
	}
	
	if ResourceLoader.exists(save_file):
		save_game = ResourceLoader.load(save_file)
		game_state_dictionary["frame_data"] = save_game.text_data
		game_state_dictionary["evidence"] = save_game.evidence

	return game_state_dictionary
