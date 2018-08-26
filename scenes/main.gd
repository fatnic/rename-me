extends Node2D

var scn_explosion = load("res://entities/explosion.tscn")

func _ready():
	add_signals_from_group("explosive", self, "spawn_explosion")


func spawn_explosion(pos, power, scl = 1.0):
	var explosion = scn_explosion.instance()
	explosion.position = pos
	explosion.get_node("aoe/CollisionShape2D").shape.radius = power
	explosion.get_node("Sprite").scale = Vector2(scl, scl)
	add_child(explosion)
	
	
func add_signals_from_group(group_name, target, method):
	for item in get_tree().get_nodes_in_group(group_name):
		item.connect(method, target, method)	