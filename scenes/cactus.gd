extends Area2D

@export var fake_collision: bool = false
@export var collision_area_to_unhide: Area2D

@onready var appeared = collision_area_to_unhide == null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !fake_collision:
		body_entered.connect(_die_if_true)

	if collision_area_to_unhide:
		visible = false
		collision_area_to_unhide.body_entered.connect(_appear)


func _appear(body: Node2D) -> void:
	if body.is_in_group("player") and !appeared:
		visible = true
		$AnimationPlayer.play("Appear")
		appeared = true
	
func _die_if_true(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().call_deferred("reload_current_scene")
