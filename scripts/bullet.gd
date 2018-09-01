extends KinematicBody2D

export (float) var radius = 0.5
export (Color) var colour
export (int) var speed

var velocity = Vector2(0, 0)

	
func start(target, pos, dir):
	position = pos
	velocity = dir * speed


func _process(delta):

	var hit = move_and_collide(velocity * delta)

	if hit:
		if hit.collider.is_in_group("explisive"): hit.collider.call_deferred("epxplode")
		if hit.collider.is_in_group("player"):
			hit.collider.punch(velocity.normalized() * 1.0)
			hit.collider.call_deferred("change_health", -2)
		queue_free()