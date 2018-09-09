extends RigidBody2D

export (PackedScene) var scn_destroyed_ship

export (int) var thrust = 22
export (float) var turn_speed = 0.8

var fuel = 1
export (float) var start_fuel = 100
export (float) var max_fuel = 100
export (float) var fuel_use = 0.2

var health = 1
export (float) var start_health = 100
export (float) var max_health = 100

export (Color, RGBA) var rope_colour

var grappling = null
var grounded = true

var integrated_pos = null
var integrated_vel = null
var integrated_rot = null

signal fuel_change
signal health_change
signal spawn_explosion
signal death


func _ready():
	pass

func _physics_process(delta):

	if health == 0:
		destruct()
		

	if Input.is_action_pressed("thrust"):
		if fuel > 0:
			thrust()
		else:
			stop_engine()
			emit_signal("death", "a lack of fuel seems to be the problem...", 2.5)
			
			
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
	

func destruct():
	emit_signal("death", "and it exploded...", 4)
	stop_engine()
	release_grapple()
	
	for i in get_tree().get_nodes_in_group("lock_on"): i.target = null
	
	var ship_destroyed = scn_destroyed_ship.instance()
	ship_destroyed.position = position
	ship_destroyed.rotation = rotation
	ship_destroyed.power = lerp(50, 150, fuel / 100)
	get_tree().get_root().get_node("main").add_child (ship_destroyed)
	emit_signal("spawn_explosion", global_position, lerp(10, 30, fuel / 100), fuel / 100)
	queue_free()
	
	
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
		

func stop_engine():
	$exhaust_flame.emitting = false
	$exhaust_glow.enabled = false
	$exhaust_sound.stop()