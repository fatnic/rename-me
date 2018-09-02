extends Node2D

var scn_explosion = load("res://entities/explosion.tscn")

export (Color) var rope_colour

func _ready():
	add_signals_from_group("explosive", self, "spawn_explosion")
	add_signals_from_group("weapon", self, "fire_weapon")
	
	add_signals_from_group("player", $ui/guages, "fuel_change")
	add_signals_from_group("player", $ui/guages, "health_change")
	add_signals_from_group("player", self, "spawn_explosion")
		
	for p in get_tree().get_nodes_in_group("player"): 
		p.call_deferred("change_fuel", p.start_fuel)
		p.call_deferred("change_health", p.start_health)
	
	
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
	
	for player in get_tree().get_nodes_in_group("player"):
		if player.grappling:
			draw_line($ship_one.position, $ship_one.grappling.position, rope_colour, 1.0)
		
	for bullet in get_tree().get_nodes_in_group("bullet"):
		draw_circle(bullet.position, bullet.radius, bullet.colour)