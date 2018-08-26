extends RigidBody2D



## Interactable variables
export (int) var interact_radius = 8
export (bool) var collect = true
export (bool) var grapple = false
var grappled_by = null

export (int) var fuel_amount = 10

signal spawn_explosion

func _physics_process(delta):
	
	if get_colliding_bodies().size() > 0:
	
		if fuel_amount > 0 and linear_velocity.length() > 30:
		
			if grappled_by: grappled_by.call("release_grapple")
			explode()
					

func explode():
	emit_signal("spawn_explosion", global_position, 20, 0.5)
	queue_free()
	

func on_collect(collector):
	
	if collector.has_method("add_fuel"):
		collector.call_deferred("add_fuel", fuel_amount)
		fuel_amount = 0
		$interactable.collect = false
		$tween.interpolate_property($glow, "energy", 1.5, 0.01, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$tween.start()
		

func on_grapple(grappler):
#	print("grappled by %s" % grappler.get_name())
	grappled_by = grappler
	grappler.call_deferred("grapple_object", self)


func _on_tween_tween_completed(object, key):	
	remove_child($glow)