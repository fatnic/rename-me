extends RigidBody2D

export (int) var thrust = 22
export (int) var max_thrust = 100
export (float) var turn_speed = 0.8

export (int) var fuel = 100
export (int) var max_fuel = 100

var grappling = null


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
		
	if Input.is_action_just_pressed("grapple"):
		if grappling:
#			print("%s is releasing %s" % [get_name(), grappling.get_name()])
			grappling.grapple = true
			grappling.grappled_by = null
			grappling = null
			$grapple.node_b = ""
			$grapple_off_sound.play()
		
	if Input.is_action_pressed("reset"):
		rotation = 0


func rotate_ship(direction):
	angular_velocity = direction * turn_speed


func thrust():
	apply_impulse(Vector2(), Vector2(0, -thrust).rotated(rotation))
	if not $exhaust_sound.playing: $exhaust_sound.play()
	$exhaust_flame.emitting = true
	$exhaust_glow.enabled = true
	
	
func add_fuel(amount):
	pass
#	print("%s has received %d fuel" % [self.get_name(), amount])
	
	
func grapple_object(object):
	
	if not grappling:
#		print("%s has grappled %s" % [self.get_name(), object.get_name()])
		grappling = object
		$grapple.node_b = object.get_path()
		$grapple_on_sound.play()
		object.grapple = false
		

func release_grapple():
	
	if grappling:
		$grapple.node_b = ""
		grappling.grappled_by = null
		grappling = null
		
		
