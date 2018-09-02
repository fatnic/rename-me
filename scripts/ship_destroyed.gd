extends Node2D

var power

func _ready():
	
	for piece in $pieces.get_children():
		var dxy = ($center.position - piece.position).normalized()
		piece.apply_impulse(Vector2(0, 0), dxy * power)
