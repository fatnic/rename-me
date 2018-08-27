extends Node2D

var scn_explosion = load("res://entities/explosion.tscn")
var scn_rocket = load("res://entities/rocket_he.tscn")


func _ready():
	add_signals_from_group("explosive", self, "spawn_explosion")
	add_signals_from_group("weapon", self, "fire_weapon")
	
func _process(delta):
	update()

	
func add_signals_from_group(group_name, target, method):
	for item in get_tree().get_nodes_in_group(group_name):
		item.connect(method, target, method)	


func spawn_explosion(pos, power = 20, scl = 1.0):
	var explosion = scn_explosion.instance()
	explosion.position = pos
	explosion.get_node("aoe/CollisionShape2D").shape.radius = power
	explosion.get_node("Sprite").scale = Vector2(scl, scl)
	add_child(explosion)
	
	
func fire_weapon(target, pos, dir):
	var rocket = scn_rocket.instance()
	rocket.connect("spawn_explosion", self, "spawn_explosion")
	rocket.start(target, pos, dir)
	add_child(rocket)

		
func _draw():
	if $ship_one.grappling:
		draw_line($ship_one.position, $ship_one.grappling.position, Color(0.501, 0.313, 0.176, 1.0), 1.0)