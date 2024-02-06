extends Button

@onready var small_arrow = $ArrowAnchor/SmallArrow

func disable(toggle: bool = true):
	disabled = toggle
	small_arrow.visible = not disabled
