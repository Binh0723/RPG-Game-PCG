extends Node

func _ready():
	var rooms = $Dungeon.rooms
	var minX = 10000
	var minY = 10000
	var firstRoom
	for room in rooms:
		if room.x + room.y < minX + minY:
			firstRoom = room
			minX = room.x
			minY = room.y
	for x in range(firstRoom.x , firstRoom.x + firstRoom.w):
		for y in range(firstRoom.y, firstRoom.y + firstRoom.h):
			if $Dungeon.get_cell(x,y) == $Dungeon.Tiles.GROUND1 || \
			$Dungeon.get_cell(x,y) == $Dungeon.Tiles.GROUND2 || \
			$Dungeon.get_cell(x,y) == $Dungeon.Tiles.GROUND3:
				$Player.position.x = (x+1) * 32
				$Player.position.y = (y + 1)* 32
				break
	
