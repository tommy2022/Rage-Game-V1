extends Label

func _process(_delta: float) -> void:
	text = "Deaths: %d" % GameState.deaths
