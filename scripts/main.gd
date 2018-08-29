extends Node2D

var scn_explosion = load("res://entities/explosion.tscn")


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
	
	
func fire_weapon(ammo, target, pos, dir):
	var projectile = ammo.instance()
	if projectile.is_in_group("explosive"): projectile.connect("spawn_explosion", self, "spawn_explosion")
	projectile.start(target, pos, dir)
	add_child(projectile)

		
func _draw():
	
	if $ship_one.grappling:
		draw_line($ship_one.position, $ship_one.grappling.position, Color(0.501, 0.313, 0.176, 1.0), 1.0)
		
	for bullet in get_tree().get_nodes_in_group("bullet"):
		draw_circle(bullet.position, bullet.radius, bullet.colour)