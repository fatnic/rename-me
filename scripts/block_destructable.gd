extends RigidBody2D

var scn_block_destructed = load("res://entities/block_destructed.tscn")


func destroy(pos, power):

	var block = scn_block_destructed.instance()
	block.position = global_position + Vector2(-8, -8)
	
	for piece in block.get_node("pieces").get_children():
		var dxy = piece.position - pos
		piece.apply_impulse(Vector2(0, 0), dxy.normalized() * 10)
		 
	queue_free()
	get_parent().add_child(block)