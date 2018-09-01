extends RigidBody2D

## Interactable variables
export (bool) var collect = true
export (bool) var grapple = true
var grappled_by = null

export (int) var fuel_amount = 25

signal spawn_explosion

func _physics_process(delta):
	
	if get_colliding_bodies().size() > 0:
	
		if fuel_amount > 0 and linear_velocity.length() > 30:
			if grappled_by: grappled_by.call("release_grapple")
			explode()
					

func explode():
		if grappled_by: grappled_by.call("release_grapple")
		emit_signal("spawn_explosion", global_position, 20, 0.3)
		queue_free()
	

func on_collect(collector):
	
	if collector.has_method("change_fuel"):
		collector.call_deferred("change_fuel", fuel_amount)
		fuel_amount = 0
		remove_from_group("explosive")
		$interactable.collect = false
		$tween.interpolate_property($glow, "energy", 1.5, 0.01, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$tween.start()
		$AudioStreamPlayer.play()
		

func on_grapple(grappler):
	grappled_by = grappler
	grappler.call_deferred("grapple_object", self)


func _on_tween_tween_completed(object, key):	
	remove_child($glow)