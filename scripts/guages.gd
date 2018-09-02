extends VBoxContainer

export (Gradient) var fuel_guage_gradient
export (Gradient) var health_guage_gradient


func fuel_change(amount):
	$tween.interpolate_property($"fuel_guage", "value", $fuel_guage.value, amount, 0.5, Tween.TRANS_LINEAR,Tween.EASE_IN)
	$tween.start()
	
	
func health_change(amount):
	$tween.interpolate_property($health_guage, "value", $health_guage.value, amount, 0.2, Tween.TRANS_LINEAR,Tween.EASE_IN)
	$tween.start()
	
	
func _on_tween_tween_step(object, key, elapsed, value):
	object.self_modulate = get("%s_gradient" % object.get_name()).interpolate(value / 100)