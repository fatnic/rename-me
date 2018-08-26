extends RigidBody2D

## Interactable variables
export (int) var interact_radius = 8
export (bool) var collect = true
export (bool) var grapple = false

export (int) var fuel_amount = 10


func on_collect(collector):
	
	if collector.has_method("add_fuel"):
		collector.call_deferred("add_fuel", fuel_amount)
		$interactable.collect = false
		$tween.interpolate_property($glow, "energy", 1.5, 0.01, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$tween.start()
		

func on_grapple(grappler):
	print("grappled by %s" % grappler.get_name())
	grappler.call_deferred("grapple_object", self)


func _on_tween_tween_completed(object, key):	
	remove_child($glow)