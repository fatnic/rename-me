extends Area2D

export (int) var speed
export (int) var steer_force

var target = null
var velocity = Vector2()
var acceleration = Vector2()

signal spawn_explosion

func start(t, pos, dir):
	target = t
	position = pos
	rotation = dir.angle()
	velocity = dir * speed
	$exhaust_sound.play()


func _process(delta):
	
	if target:
		acceleration += seek()
		velocity += acceleration * delta
		velocity = velocity.clamped(speed)
		rotation = velocity.angle()
		
	position += velocity * delta
	

func seek():
	var desired = (target.position - position).normalized() * speed
	var steer = (desired - velocity).normalized() * steer_force
	return steer
	

func _on_rocket_he_body_entered(body):
	emit_signal("spawn_explosion", position, 20, 0.5)
	queue_free()