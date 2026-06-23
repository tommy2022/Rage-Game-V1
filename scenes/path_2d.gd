extends Path2D

@export var platform_to_reveal: Platform
@export var trigger_point: Area2D

# Adjust this to change how fast the platform moves
@export var speed: float = 0.4

@onready var path_follow: PathFollow2D = $PathFollow2D

var revealed_platform: bool = false
var player_entered: bool = false

func _ready() -> void:
	platform_to_reveal.enable(false)
	trigger_point.body_entered.connect(_check_for_player)

func _process(delta: float) -> void:
	if !player_entered:
		return
	
	_move_platform(delta)


func _move_platform(delta: float) -> void:
	# Advance the progress ratio by speed multiplied by time
	path_follow.progress_ratio += speed * delta
	
	if path_follow.progress_ratio >= 1.0 and not revealed_platform:
		platform_to_reveal.enable()
		revealed_platform = true

func _check_for_player(body: Node2D):
	if body.is_in_group("player"):
		player_entered = true
