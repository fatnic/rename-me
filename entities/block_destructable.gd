extends RigidBody2D


func destroy():
	mode = RigidBody2D.MODE_RIGID
	queue_free()