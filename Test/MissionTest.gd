extends Node


enum Status {NOT_STARTED, STARTED, COMPLETED}

var goal_kill_monsters = 5
var monster_Spawner = 5
var quest_status = Status.NOT_STARTED
#var dungeon = get_tree().root.get_node("Maze/Dungeon") 
#var player = get_tree().root.get_node("Maze/Player")
#onready var dungeon =get_node("Maze/Dungeon") 
#onready var player = get_node("Maze/Player")
onready var dungeon
onready var player
var spawner_area = preload("res://Enitities/Monsters/Immortal-Spider/Immortal_Spider.tscn")
var room
func checkArea(position: Vector2, room):
	var x = room.x
	var y = room.y
	var w = room.w
	var h = room.h
	if position.x >= x and position.x <= x + w and position.y >= y and position.y <= y+h:
		return true
	return false

func _ready():

	var rooms = dungeon.rooms
	room = Util.choose(rooms)

func _process(delta):
	if(checkArea(player.position,room)):
		quest_status = Status.STARTED
		var x = room.x
		var y = room.y
		var w = room.w
		var h = room.h
		for i in range(monster_Spawner):
			for x in range(x + w):
				for y in range(y + h):
					var spider = spawner_area.instance()
					add_child(spider)
					spider.position.x = x * 32
					spider.position.y = y * 32
					
		
		
	
	
