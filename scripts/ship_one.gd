extends RigidBody2D

export (int) var thrust = 22
export (float) var turn_speed = 0.8

export (float) var fuel = 0
export (float) var max_fuel = 100
export (float) var fuel_use = 0.2

export (float) var health = 0
export (float) var max_health = 100

var grappling = null
var grounded = true

var integrated_pos = null
var integrated_vel = null
var integrated_rot = null

signal fuel_change
signal health_change

func _ready():
	pass
	

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
			grappling.grapple = true
			grappling.grappled_by = null
			grappling = null
			$grapple.node_b = ""
			$grapple_off_sound.play()
			
		
	if grounded and Input.is_action_pressed("reset"):
		$tween.interpolate_property(self, "rotation", rotation, 0, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$tween.start()
		

func _process(delta):
	update()
		

func rotate_ship(direction):
	angular_velocity = direction * turn_speed


func thrust():
	apply_impulse(Vector2(), Vector2(0, -thrust).rotated(rotation))
	change_fuel(-fuel_use * get_process_delta_time())
	if not $exhaust_sound.playing: $exhaust_sound.play()
	$exhaust_flame.emitting = true
	$exhaust_glow.enabled = true
	
	
func change_fuel(amount):
	fuel = clamp(fuel + amount, 0, max_fuel)
	var fuel_percent = fuel * 100 / max_fuel
	emit_signal("fuel_change", fuel_percent)
	
	
func change_health(amount):
	health = clamp(health + amount, 0, max_health)
	var health_percent = health * 100 / max_health
	emit_signal("health_change", health_percent)	
	
	
func punch(vel):
	integrated_vel = vel
	
	
func _integrate_forces(state):
	
	var xform = state.get_transform()
	
	if integrated_vel:
		xform.origin += integrated_vel
		integrated_vel = null
		
	if integrated_rot:
		xform.rotated(-xform.get_rotation())
		integrated_rot = null
		
	state.set_transform(xform)
	
	
func grapple_object(object):
	
	if not grappling:
		grappling = object
		$grapple.node_b = object.get_path()
		$grapple_on_sound.play()
		object.grapple = false
		

func release_grapple():
	
	if grappling:
		$grapple.node_b = ""
		grappling.grappled_by = null
		grappling = null