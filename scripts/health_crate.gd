extends Sprite

export (bool) var collect = true

export (float) var health_amount = 25


func on_collect(collector):
	
	if collector.has_method("change_health"):
		collector.call_deferred("change_health", health_amount)
		$interactable.collect = false
		$tween.interpolate_property($glow, "energy", 1.5, 0.01, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$tween.start()
		$AnimationPlayer.play("fade_out")
		collector.get_node("fix").play()
		
	
func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()