extends Control

## On-screen virtual controls for touch devices.
##
## Uses raw screen-touch events (not GUI Buttons) so multiple fingers can be
## held at once — e.g. holding "left" while tapping "jump". Each button maps to
## one of the existing input actions, pressed/released via the Input singleton
## so the rest of the game keeps using Input.is_action_pressed() unchanged.

@export var button_radius := 70.0
@export var margin := 90.0

# Each button: { action, center, label }
var _buttons: Array[Dictionary] = []
# Active fingers: touch index -> button index it is currently pressing.
var _touches := {}

func _ready() -> void:
	# Only show (and process touches) on devices that actually have a touchscreen.
	if not DisplayServer.is_touchscreen_available():
		hide()
		set_process_input(false)
		return

	mouse_filter = Control.MOUSE_FILTER_IGNORE
	get_viewport().size_changed.connect(_layout)
	_layout()

func _layout() -> void:
	var vp := get_viewport_rect().size
	var y := vp.y - margin
	_buttons = [
		{"action": &"ui_left", "center": Vector2(margin, y), "label": "<"},
		{"action": &"ui_right", "center": Vector2(margin + button_radius * 2.2, y), "label": ">"},
		{"action": &"ui_accept", "center": Vector2(vp.x - margin, y), "label": "JUMP"},
	]
	queue_redraw()

func _button_at(pos: Vector2) -> int:
	for i in _buttons.size():
		if pos.distance_to(_buttons[i]["center"]) <= button_radius:
			return i
	return -1

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			var b := _button_at(event.position)
			if b >= 0:
				_touches[event.index] = b
				Input.action_press(_buttons[b]["action"])
				get_viewport().set_input_as_handled()
		elif _touches.has(event.index):
			Input.action_release(_buttons[_touches[event.index]]["action"])
			_touches.erase(event.index)
			get_viewport().set_input_as_handled()
	elif event is InputEventScreenDrag and _touches.has(event.index):
		# Finger slid between buttons (or off them) without lifting.
		var prev: int = _touches[event.index]
		var now := _button_at(event.position)
		if now != prev:
			Input.action_release(_buttons[prev]["action"])
			_touches.erase(event.index)
			if now >= 0:
				_touches[event.index] = now
				Input.action_press(_buttons[now]["action"])

func _exit_tree() -> void:
	for finger in _touches:
		Input.action_release(_buttons[_touches[finger]]["action"])
	_touches.clear()

func _draw() -> void:
	var font := ThemeDB.fallback_font
	var fs := 28
	for b in _buttons:
		var center: Vector2 = b["center"]
		var pressed := _touches.values().has(_buttons.find(b))
		var fill := Color(1, 1, 1, 0.30) if pressed else Color(1, 1, 1, 0.16)
		draw_circle(center, button_radius, fill)
		draw_arc(center, button_radius, 0, TAU, 48, Color(1, 1, 1, 0.6), 3.0, true)
		var label: String = b["label"]
		var ts := font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
		var pos := Vector2(center.x - ts.x / 2.0, center.y + fs * 0.35)
		draw_string(font, pos, label, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color.WHITE)
