extends Node2D

var scn_explosion = load("res://entities/explosion.tscn")

#export (Color) var rope_colour

var death_message = ""

func _ready():
	add_signals_from_group("sound", self, "play_sound")
	add_signals_from_group("sound", self, "stop_sound")
	
	add_signals_from_group("explosive", self, "spawn_explosion")
	add_signals_from_group("weapon", self, "fire_weapon")
	
	add_signals_from_group("player", $ui/guages, "fuel_change")
	add_signals_from_group("player", $ui/guages, "health_change")
	add_signals_from_group("player", self, "spawn_explosion")
	add_signals_from_group("player", self, "death")
		
	for p in get_tree().get_nodes_in_group("player"): 
		p.call_deferred("change_fuel", p.start_fuel)
		p.call_deferred("change_health", p.start_health)
	
	
func _process(delta):
	update()

	
func add_signals_from_group(group_name, target, method):
	for item in get_tree().get_nodes_in_group(group_name):
		item.connect(method, target, method)	


func play_sound(sound):
	$sounds.get_node(sound).play()
	
	
func stop_sound(sound):
	$sounds.get_node(sound).stop()
	

func spawn_explosion(pos, power = 20, scl = 1.0):
	var explosion = scn_explosion.instance()
	explosion.position = pos
	explosion.get_node("aoe/CollisionShape2D").shape.radius = power
	explosion.get_node("Sprite").scale = Vector2(scl, scl)
	$sounds/explosion.play()
	add_child(explosion)
	
	
func fire_weapon(ammo, target, pos, dir):
	var projectile = ammo.instance()
	if projectile.is_in_group("explosive"): projectile.connect("spawn_explosion", self, "spawn_explosion")
	projectile.start(target, pos, dir)
	add_child(projectile)
	
	
func death(message):
	$top_overlay/death_screen/message.text = message
	$top_overlay/death_screen/timer.start()
	
#
#func _draw():
#
#	for player in get_tree().get_nodes_in_group("player"):
#		if player.grappling:
#			draw_line(player.position, player.grappling.position, rope_colour, 1.0)
		

func _on_timer_timeout():
	$top_overlay/anim.play("fade_in")