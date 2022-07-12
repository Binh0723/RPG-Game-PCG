extends Node

enum QuestStatus {NOT_STARTED,STARTED,COMPLETED}

signal Activated(room)
signal Completed(room)

var quest_status = QuestStatus.NOT_STARTED

var AllRooms 
var room1
var room2
var room3
var dungeon
var player
var treasurechest = preload("res://Inventory/Treasure/Treasure.tscn")
var gold_ins = preload("res://Inventory/Gold/Gold.tscn")
var key_ins = preload("res://Inventory/Keys/Key.tscn")
#onready var player = $Player
func _ready():
	dungeon =get_tree().root.get_node("Maze/Dungeon")
	AllRooms = dungeon.rooms.duplicate()
	room2 = Util.choose(AllRooms)
	AllRooms.erase(room2)
	print(room2.x)
	print(room2.y)
	room3 = Util.choose(AllRooms)
	print(room3.x)
	print(room3.y)
	var treasure = treasurechest.instance()
	var key = key_ins.instance()
	add_child(treasure)
	add_child(key)
	treasure.position.x = room2.center.x * 32
	treasure.position.y = room2.center.y * 32
	key.position.x = room3.center.x * 32
	key.position.y = room3.center.y * 32
	treasure.connect("Completed", self, "Gold_arise")


func Gold_arise():
	var gold = gold_ins.instance()
	add_child(gold)
	gold.position.x = room2.center.x * 32
	gold.position.y = room2.center.y * 32
	
		
