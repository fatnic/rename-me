extends RigidBody2D

export (int) var thrust = 22
export (int) var max_thrust = 100
export (float) var turn_speed = 0.8


func _physics_process(delta):
	
	if Input.is_action_pressed("thrust"):
		thrust()
	
	if Input.is_action_just_released("thrust"):
		$exhaust_flame.emitting = false
		$exhaust_glow.enabled = false
		$exhaust_sound.stop()
		
	if Input.is_action_pressed("turn_left"):
		rotate_ship(-1)
		
	if Input.is_action_pressed("turn_right"):
		rotate_ship(1)
		
	if Input.is_action_pressed("reset"):
		rotation = 0


func rotate_ship(direction):
	angular_velocity = direction * turn_speed


func thrust():
	apply_impulse(Vector2(), Vector2(0, -thrust).rotated(rotation))
	if not $exhaust_sound.playing: $exhaust_sound.play()
	$exhaust_flame.emitting = true
	$exhaust_glow.enabled = true
	