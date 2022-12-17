extends Node

# Conversation to point towards when pressing this statement. Button disappears if empty.
export(Array) var press_convo = []

# Array of correct evidence that will break out of the statement on present
export(Array) var present_correct = []

# If this statement is visible right off the bat, or is hidden and has to be revealed
export(bool) var is_visible = true 

# Evidence has been correctly presented according to present_correct array
signal evidence_presented(correct)

func present_evidence(evidence: String):
	emit_signal("evidence_presented", present_correct.has(evidence))
