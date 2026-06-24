extends CharacterBody2D

@export var breakable_layers: Array[TileMapLayer] = []

const SPEED = 150.0
const JUMP_VELOCITY = -300.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor() and (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")):
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider is TileMapLayer and collider in breakable_layers:
			var breakable_layer = collider as TileMapLayer

			breakable_layer.collision_enabled = false
			breakable_layer.visible = false
	
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true

	move_and_slide()
