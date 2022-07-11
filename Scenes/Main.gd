extends Node



#var tilemap_scene = preload("res://TilesSet/TileMap.tscn")
#var player_scene = preload("res://Enitities/Player/Player.tscn")
#var player

func _ready():
	var caves = $TileMap.caves
	var cave = Util.choose(caves)
	for tile in cave:
		if($TileMap.get_cell(tile.x,tile.y) == $TileMap.Tiles.GROUND and $TileMap.get_cell(tile.x,tile.y + 1) == $TileMap.Tiles.GROUND\
			and Util.chance(1) and $TileMap.get_cell(tile.x,tile.y - 1) == $TileMap.Tiles.GROUND):
			$Portal.position.x = tile.x * 32
			$Portal.position.y = tile.y * 32
	for position in cave:
		if ($TileMap.get_cellv(position) == $TileMap.Tiles.GROUND) && Util.chance(1):
			$Player.position = position * 32
			break
	




	
	
	
