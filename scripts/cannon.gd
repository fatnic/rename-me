extends RigidBody2D

var target = null
var line_of_sight = false
var on_cooldown = false

signal fire_weapon

func _process(delta):
	
	if target:
		line_of_sight = false
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(global_position, target.global_position, [self])
		if result:
			if result.collider.is_in_group("player"):
				line_of_sight = true
				
				
	if not on_cooldown and target and line_of_sight:
		on_cooldown = true
		$cooldown.start()
		emit_signal("fire_weapon", target, position + Vector2(16, 0), Vector2(1, 0))
		

func _on_range_body_entered(body):
	target = body

func _on_range_body_exited(body):
	target = null

func _on_cooldown_timeout():
	on_cooldown = false