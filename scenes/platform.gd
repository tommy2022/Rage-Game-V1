extends StaticBody2D
class_name Platform

@onready var _collider: CollisionShape2D = $Collider
@onready var _area_trigger: Area2D = $Trigger

@export var disappearing_platform: bool = false
@export var false_platform: bool = false

var _triggered: bool = false

func _ready() -> void:
	if false_platform:
		_collider.disabled = true

	if has_body_entered_trigger():
		_area_trigger.body_entered.connect(_on_body_entered)

func enable(enabled: bool = true) -> void:
	_collider.disabled = !enabled
	self.visible = enabled

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not _triggered:
		_disapper()
		_triggered = true

func _disapper() -> void:
	call_deferred("enable", false)

func has_body_entered_trigger() -> bool:
	return disappearing_platform
