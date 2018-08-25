extends Light2D

func _physics_process(delta):
	if enabled:
		texture_scale = rand_range(0.5, 0.8)
		energy = rand_range(0.7, 1.0)