extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if is_on_floor() and (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var platform_velocity = Vector2.ZERO
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is AnimatableBody2D and collision.get_collider().has_method("get_platform_velocity"):
			platform_velocity = collision.get_collider().get_platform_velocity()
			velocity.x += platform_velocity.x

	move_and_slide()
