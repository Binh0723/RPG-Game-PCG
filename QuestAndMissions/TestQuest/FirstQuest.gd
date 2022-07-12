extends Node

enum QuestStatus {NOT_STARTED,STARTED,COMPLETED}

signal Activated(room)
signal Completed(room)

var quest_status = QuestStatus.NOT_STARTED
var Stone = preload("res://Inventory/Stone/GreenStone.tscn")
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
#	print(room1.x)
#	print(room1.y)
func _process(delta):
	var x = room1.x
	var y = room1.y
	var w = room1.w
	var h = room1.h
	if(quest_status == QuestStatus.NOT_STARTED and player.position.x >= x * 32 and player.position.x <= (x + w)* 32 and \
		player.position.y >= y * 32 and player.position.y <= (y+h)* 32):
			quest_status = QuestStatus.STARTED
			emit_signal("Activated",room1)
	if(quest_status == QuestStatus.STARTED and $GoblinSpawnerRoom.goblin_count == 0):
		quest_status = QuestStatus.COMPLETED
		emit_signal("Completed",room1)
		print(quest_status)
			
		
func _on_FirstQuest_Completed(room):
	var stone = Stone.instance()
	add_child(stone)
	stone.position.x = room.center.x * 32
	stone.position.y = room.center.y * 32
