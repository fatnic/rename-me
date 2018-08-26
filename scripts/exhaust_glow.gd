extends Light2D

export (Vector2) var tex_scale
export (Vector2) var energy_scale

func _physics_process(delta):
	
	if enabled:
		texture_scale = rand_range(tex_scale.x, tex_scale.y)
		energy = rand_range(energy_scale.x, energy_scale.y)