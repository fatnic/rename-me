extends Node2D

var target = null
var seen = false

func _process(delta):

	seen = false
	
	if target:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(global_position, target.global_position, [get_parent()], get_parent().collision_mask)
		
		if result:
			if result.collider == target:
				seen = true