extends Node

enum QuestStatus {NOT_STARTED,STARTED,COMPLETED}

signal NotActivate
signal Activated(room)
signal Completed

var quest_status = QuestStatus.NOT_STARTED

var AllRooms 
var room1
var room2
var room3
var dungeon
var player
var activate_quest = false
#onready var player = $Player
func _ready():
	dungeon =get_tree().root.get_node("Maze/Dungeon")
	AllRooms = dungeon.rooms
	room1 = Util.choose(AllRooms)
	player = get_tree().root.get_node("Maze/Player")
	print(room1.x)
	print(room1.y)
func _process(delta):
	var x = room1.x
	var y = room1.y
	var w = room1.w
	var h = room1.h
	if(player.position.x >= x * 32 and player.position.x <= (x + w)* 32 and \
		player.position.y >= y * 32 and player.position.y <= (y+h)* 32 and not activate_quest):
			quest_status = QuestStatus.STARTED
			activate_quest = true
			print(quest_status)
			emit_signal("Activated",room1)
			
		
