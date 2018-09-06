tool
extends Node2D

export (Texture) var map
export (bool) var is_autotile = false
export (bool) var generate = false

const N = 1
const E = 2
const S = 4
const W = 8

const walls = { Vector2(0, -1): N, Vector2(1, 0): E, Vector2(0, 1): S, Vector2(-1, 0): W }

var map_width = 0
var map_height = 0

var tilemap = get_parent()


func _process(delta):
	if generate: 
		generate = false
		gen()
			
			
func gen():
	var image = map.get_data()
	image.lock()
	map_width = image.get_width()
	map_height = image.get_height()
	
	for y in range(map_height):
		for x in range(map_width):
			var c = str(image.get_pixel(x, y))
			var t = -1
			
			match c:
				"0,0,0,1" : t = 0
				
			tilemap.set_cell(x, y, t)
	
	image.unlock()
	
	if is_autotile: autotile()
	

func autotile():
	
	for y in range(map_height):
		for x in range(map_width):
			
			if tilemap.get_cell(x, y) > -1:
				var tile = calc_tile(x, y)	
				tilemap.set_cell(x, y, tile)
						
						
func calc_tile(x, y):
	var tile = 0
	for w in walls.keys():
		var cn = Vector2(x, y) + w #current_neighbour
		if cn.x < 0 or cn.x > map_width - 1 or cn.y < 0 or cn.y > map_height - 1: 
			tile += walls[w]
		var neighbour = tilemap.get_cellv(cn)
		if neighbour > -1: tile += walls[w]
		
	return tile