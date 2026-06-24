extends Area2D

@onready var win_screen: CanvasLayer = $WinScreen
@onready var title: Label = $WinScreen/Title

var reached := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	win_screen.visible = false
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if reached or not body.is_in_group("player"):
		return

	reached = true
	var deaths := GameState.deaths
	title.text = "Stage Complete!\n%d %s" % [deaths, "death" if deaths == 1 else "deaths"]
	win_screen.visible = true
	get_tree().paused = true

func _unhandled_input(event: InputEvent) -> void:
	if not reached:
		return
	# Restart on jump/accept (keyboard) or a screen tap (mobile).
	if event.is_action_pressed("ui_accept") or (event is InputEventScreenTouch and event.pressed):
		GameState.reset()
		get_tree().paused = false
		get_tree().reload_current_scene()
