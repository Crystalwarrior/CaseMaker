extends Node

# A command just started  processing
signal command_started()

# A command just finished processing
signal command_finished()

# Command array reached its final command
signal final_command()
