tool
extends Node2D

export (Texture) var map_image
export (Color) var wall_colour
export (bool) var generate = false
#var new_generation = true

const walls = { Vector2(0, -1): 1, Vector2(1, 0): 2, Vector2(0, 1): 4, Vector2(-1, 0): 8 }

var map_width = 0
var map_height = 0

var spawnables = {}
var spawned = []


func _ready():
	if not Engine.is_editor_hint():	generate = true
		
		
func _process(delta):

	if generate:
		generate = false
		parse_json_spawnables()
		remove_children([$interactables, $antagonists, $destructables, $actors])
		spawned = []
		parse_image()
		get_parent().sync_signals()
		
		
func remove_children(nodes):
	for node in nodes:
		for child in node.get_children(): node.remove_child(child)


func parse_json_spawnables():
	for s in get_json("res://resources/config/spawnables.json"):
		spawnables[s.colour] = { "scn": s.scene, "parent": s.parent }
		if s.has("offset"): spawnables[s.colour].offset = Vector2(s.offset[0], s.offset[1])
		if s.has("clamp_v"): spawnables[s.colour].clamp_v = s.clamp_v
		if s.has("clamp_h"): spawnables[s.colour].clamp_h = s.clamp_h
		
				
func get_json(file):
	var data_file = File.new()
	data_file.open(file, File.READ)
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.parse(data_text)
	return data_parse.result
	

func parse_image():

	var image = map_image.get_data()
	image.lock()
	
	map_width = image.get_width()
	map_height = image.get_height()
	
	for y in range(map_height): # clear the tilemap
		for x in range(map_width):
			$environment.set_cell(x, y, -1)
	
	var wc = str(wall_colour)
	
	for y in range(map_height):
		for x in range(map_width):
			
			var c = str(image.get_pixel(x, y))
			if c == wc: 
				$environment.set_cell(x, y, 1) 
				continue
			
			if spawnables.has(c):
				spawned.append([x, y, spawnables[c]])
				continue
			
	
	image.unlock()
	autotile()
	add_spawned_to_map()
	
	
func autotile():
	for y in range(map_height):
		for x in range(map_width):
			
			if $environment.get_cell(x, y) > -1:
				var tile = calc_tile(x, y)	
				$environment.set_cell(x, y, tile)
						

func calc_tile(x, y):
	var tile = 0
	for w in walls.keys():
		var cn = Vector2(x, y) + w #current_neighbour
		if cn.x < 0 or cn.x > map_width - 1 or cn.y < 0 or cn.y > map_height - 1: 
			tile += walls[w]
		var neighbour = $environment.get_cellv(cn)
		if neighbour > -1: tile += walls[w]
		
	return tile
	
	
func add_spawned_to_map():
	for spawn in spawned:
		add_spawnable(spawn[0], spawn[1], spawn[2])
		

func add_spawnable(x, y, item):
	var s = load(item.scn).instance()
	var sprite_size = s.get_node("Sprite").texture.get_size()
	var world_pos = $environment.map_to_world(Vector2(x, y))
	s.rotation = check_clamp(item, x, y)
	s.position = world_pos + Vector2(8, 8) + Vector2(item.offset.x, item.offset.y).rotated(s.rotation)
	get_node(item.parent).add_child(s)
	s.set_owner(get_tree().get_edited_scene_root())
	

func check_clamp(item, x, y):
	
	if item.has("clamp_v"):
		if $environment.get_cell(x, y + 1) > -1: return 0
		if $environment.get_cell(x, y - 1) > -1: return deg2rad(180)
	
	if item.has("clamp_h"):
		if $environment.get_cell(x + 1, y) > -1: return deg2rad(270)
		if $environment.get_cell(x - 1, y) > -1: return deg2rad(90)
		
	return 0

func _on_level_tree_entered():
	pass