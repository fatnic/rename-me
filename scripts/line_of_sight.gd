extends Node

var target = null
var seen = false
var hit_point = null


func _process(delta):

	seen = false
	hit_point = null

	
	if target:
		
		var space_state = get_parent().get_world_2d().direct_space_state
		var result = space_state.intersect_ray(get_parent().global_position, target.global_position, [get_parent()], get_parent().collision_mask)
		
		if result:
			hit_point = result.position
			if result.collider == target:
				seen = true