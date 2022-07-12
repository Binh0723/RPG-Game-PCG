extends Node2D

var dungeon
var rooms

export var max_goblin = 10
var start_goblin = 1
var goblin_count = 0
var goblin_class = preload("res://Enitities/Monsters/Goblin/Goblin.tscn")
var active = false

func instance_goblin(room):
	var goblin = goblin_class.instance()
	add_child(goblin)
	goblin.connect("death", self, "_on_Goblin_death")
	var valid_position = false
	while not valid_position:
		var point = randomPoint(room)
		print(point)
		goblin.position.x = point.x * 32
		goblin.position.y = point.y * 32
		
		valid_position = test_position(goblin.position)
	goblin.arise()
	
func test_position(position : Vector2):
	var cell_coord = dungeon.world_to_map(position)
	var cell_type_id = dungeon.get_cellv(cell_coord)
	var ground = (cell_type_id == dungeon.tile_set.find_tile_by_name("GROUND1")) 
	
	return ground
	
func randomPoint(room):
	var x = room.x
	var y = room.y
	var w = room.w
	var h = room.h
	var ranx = randi()%(int(w)) + x
	var rany = randi()%(int(h)) + y 

	return Vector2(ranx,rany)
func _ready():
	dungeon = get_tree().root.get_node("Maze/Dungeon")
	rooms = dungeon.rooms


func _on_Goblin_death():
	goblin_count = goblin_count - 1
	


func _on_FirstQuest_Activated(room):
	if not active:
		active = true
		for i in range(start_goblin):
			instance_goblin(room)
		goblin_count = start_goblin
		
#

#
