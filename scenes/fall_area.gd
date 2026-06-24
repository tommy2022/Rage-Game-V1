extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_die)

func _die(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.die()
