extends Node2D

export (Color) var rope_colour

func _process(delta):
	update()
	
func _draw():
	for player in get_tree().get_nodes_in_group("player"):
		if player.grappling:
			draw_line(player.position, player.grappling.position, rope_colour, 1.0)