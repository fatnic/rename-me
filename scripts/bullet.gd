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
		queue_free()
	

#func _on_bullet_body_entered(body):	
#	if body.is_in_group("explosive"): body.call_deferred("explode")
#	queue_free()