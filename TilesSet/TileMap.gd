tool
extends TileMap


export(int)   var map_w  = 130
export(int)   var map_h  = 90


export(float, 0.1, 0.4) var raioMinV = 0.4
export(float, 0.6, 0.9) var ratioMaxV = 0.6
export(float, 0.1, 0.4) var raioMinH = 0.4
export(float, 0.6, 1)  var ratioMaxH = 0.6

enum Tiles {DIRT = 7,SAND = 1,OPATH = 6,PATH = 5,GROUND = 2,WATER = 3}


var w1 
var w2 
var h1 
var h2
var region_id = 1
var ground_chance = 1
var cave_id = 0

var ground_Area = []
var caves = []
var cavesCheck = []
var hole_region = []
var shore_lines = []
var sandregion = []
var ground_path = []

var in4caves = {}
var areas = {}



var iterationCave = 3
var iterationFill = 2;


func _ready():
	generate()
	print(Tiles.DIRT)
	
	
func generate():
	clear()
	fill_roof()
	divide_region()
	random_ground()
	dig_caves_all(iterationCave)
	fill_ground(iterationFill)
	get_caves()
	connect_caves()

#fill the whole map with DIRT tiles
func fill_roof():
	for x in range(0, map_w):
		for y in range(0 , map_h):
			set_cell(x,y,Tiles.DIRT)
	
#divide the regions into many pieces		
func divide_region():
	randomize()
	var ratioV = rand_range(raioMinV, ratioMaxV)
	var ratioH = rand_range(raioMinH, ratioMaxH)
	
#	the ratio of horizontal cut
	w1 = floor(ratioV* map_w)
	w2 = map_w - w1
	
#	the ratio of vertical cut
	h1 = floor(ratioH* map_h)
	h2 = map_h - h1
	
	areas[region_id] = {x = 1,y = 1,w = w1,h = h1}
	region_id += 1
	areas[region_id] = {x = w1 + 1,y = 1,w = w2,h = h1}
	region_id += 1
	areas[region_id] = {x = 1,y = h1 + 1,w = w1,h = h2}
	region_id += 1
	areas[region_id] = {x = w1 + 1,y = h1 + 1,w = w2,h = h2}
	
#add random GROUND tiles into the map
func random_ground():
	for region_id in areas:
		var area = areas[region_id]
		var x = area.x
		var y = area.y
		var w = area.w
		var h = area.h
		for i in range(x +1, x + w -2 ):
			for j in range(y + 1 , y + h - 2 ):
				if Util.chance(ground_chance):
					set_cell(i, j, Tiles.GROUND)

#get all tiles that fullfill the requirements for cellular automata
func get_tile_area(regi_id):
	var area = areas[regi_id]
	var x = area.x
	var y = area.y
	var w = area.w
	var h = area.h
	
	var location = Vector2()
	for i in range(x + 1, x + w -1):
			for j in range(y + 1, y + h - 1 ):
				if(get_cell(i, j) == Tiles.DIRT && check_nearby(i, j, Tiles.GROUND) > 0):
					location.x = i
					location.y = j
					ground_Area.append(location)
				
#Applying cellular automata for the whole map	
func dig_caves_all(iteration):
	for i in range (0,iteration):
		for region_id in areas:
			get_tile_area(region_id)
			for tile in ground_Area:
				if Util.chance(75):
					set_cell(tile.x,tile.y,Tiles.GROUND)
				
#check how many tiles of specific kind that is surrounded the selected tile	
func check_nearby(x, y, typeTiles):
	var count = 0
	if get_cell(x, y-1)   == typeTiles:  count += 1
	if get_cell(x, y+1)   == typeTiles:  count += 1
	if get_cell(x-1, y)   == typeTiles:  count += 1
	if get_cell(x+1, y)   == typeTiles:  count += 1
	if get_cell(x+1, y+1) == typeTiles:  count += 1
	if get_cell(x+1, y-1) == typeTiles:  count += 1
	if get_cell(x-1, y+1) == typeTiles:  count += 1
	if get_cell(x-1, y-1) == typeTiles:  count += 1

	return count

#fill the hole of inside the regions
func fill_ground(iterate):
	for i in range(0,iterate):

		for cell in get_used_cells():
			if get_cellv(cell) == Tiles.DIRT && check_nearby(cell.x,cell.y,Tiles.GROUND) > 3:
				var location = Vector2(cell.x,cell.y)
				ground_Area.append(location)
		for item in ground_Area:
			set_cellv(item,Tiles.GROUND)
		
#check which regions is big enough to keep
func flood_fill(tilex, tiley):
	
	var cave = []
	var to_fill = [Vector2(tilex, tiley)]
	
	while to_fill:
		var tile = to_fill.pop_back()
	
		if !cave.has(tile):
#			
			cave.append(tile)
			cavesCheck.append(tile)
			set_cellv(tile, Tiles.DIRT)
			
			var north = Vector2(tile.x, tile.y-1)
			var south = Vector2(tile.x, tile.y+1)
			var east  = Vector2(tile.x+1, tile.y)
			var west  = Vector2(tile.x-1, tile.y)

			for dir in [north, south, east, west]:
				if get_cellv(dir) == Tiles.GROUND:
					if !to_fill.has(dir) and !cave.has(dir):
						to_fill.append(dir)
	if cave.size() >= 600:
		caves.append(cave)

#get the regions completely
func get_caves():
	for x in range (1, map_w - 1):
		for y in range (1, map_h - 1):
			if get_cell(x, y) == Tiles.GROUND and !cavesCheck.has(Vector2(x,y)):
				flood_fill(x,y)
	for cave in caves:
		for tile in cave:
			set_cellv(tile, Tiles.GROUND)
	for cell in get_used_cells():
		if get_cellv(cell) == Tiles.GROUND and check_nearby(cell.x,cell.y,Tiles.DIRT) > 0:
			shore_lines.append(cell)
	for cell in shore_lines:
		set_cellv(cell,Tiles.SAND)
		
	for cell in get_used_cells():
		if get_cellv(cell) == Tiles.DIRT:
			set_cellv(cell,Tiles.WATER)

		
func get_sand_region():
	
	for cave in caves:
		var sand = []
		for tile in cave:
			if get_cellv(tile) == Tiles.SAND:
				sand.append(tile)
		sandregion.append(sand)
		
		
func connect_caves():
	get_sand_region()
	var prev_cave = null
	var tunnel_caves = sandregion.duplicate()
	
	for cave in tunnel_caves:
		if prev_cave!= null:
			var array = short_way(cave, prev_cave)
			var new_point  = array[0]
			var prev_point = array[1]

			create_tunnel(new_point, prev_point, cave)

		prev_cave = cave

# do a drunken walk from point1 to point2
func create_tunnel(point1, point2, cave):
	if(point1 != null && point2 != null):
		randomize()          # for randf
		var max_steps = 500  # so editor won't hang if walk fails
		var steps = 0
		var drunk_x = point2.x
		
		var drunk_y = point2.y
	
		while steps < max_steps and !cave.has(Vector2(drunk_x, drunk_y)):
			steps += 1
	
			# set initial dir weights
			var n       = 1.0
			var s       = 1.0
			var e       = 1.0
			var w       = 1.0
			var weight  = 1
			var dx
			var dy

			if drunk_x < point1.x: # drunkard is left of point1
				dx = 1
				dy = 0
			elif drunk_x > point1.x: # drunkard is right of point1
				dx = -1
				dy = 0
			if drunk_y < point1.y: # drunkard is above point1
				dy = 1
				dx = 0
			elif drunk_y > point1.y: # drunkard is below point1
				dy = -1
				dx = 0
			if (2 < drunk_x + dx and drunk_x + dx < map_w-2) and \
				(2 < drunk_y + dy and drunk_y + dy < map_h-2):
				drunk_x += dx
				drunk_y += dy
				if get_cell(drunk_x, drunk_y) == Tiles.WATER:
					set_cell(drunk_x, drunk_y, Tiles.PATH)
					
func dist(x1,y1,x2,y2):
	return (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2)

func short_way(cave_1,cave_2):
	var minD = 10000
	var array = []
	var lo1 
	var lo2 
	for cell in cave_1:
#		if get_cellv(cell) != Tiles.SAND:
#			continue
		for cell2 in cave_2:
#			if get_cellv(cell) != Tiles.SAND:
#				continue
			var x1 = cell.x	
			var y1 = cell.y	
			var x2 = cell2.x	
			var y2 = cell2.y
			var dis = dist(x1,y1,x2,y2)
			if dis < minD:
				lo1 = Vector2(x1,y1)
				lo2 = Vector2(x2,y2)	
				minD = dis
	
	array.append(lo1)
	array.append(lo2)
	return array
