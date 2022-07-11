extends Node2D

var tilemap
export var max_spider = 10
var start_spider = 5
var spider_count = 0
var Immortal_Spider_scene = preload("res://Enitities/Monsters/Immortal-Spider/Immortal_Spider.tscn")
var Poison_Spider_scene = preload("res://Enitities/Monsters/Poison-Spider/Poison_Spider.tscn")
var Speed_Spider_scene = preload("res://Enitities/Monsters/Speed_Spider/Speed_Spider.tscn")
var Red_Spider_scene = preload("res://Enitities/Monsters/Red-Spider/Red_Spider.tscn")


var spiderRedCount = 0
var spiderBlueCount = 0
var spiderYellowCount = 0
var spiderGreenCount = 0

var spider_array = [ Immortal_Spider_scene, Poison_Spider_scene,Speed_Spider_scene ,Red_Spider_scene]
func instance_spider(cave):
	var spider = Util.choose(spider_array).instance()
	add_child(spider)
	spider.connect("death", self, "_on_Spider_death")
	var valid_position = false
	while not valid_position:
		var point = randomPoint(cave)
		spider.position.x = point.x * 32
		spider.position.y = point.y * 32
		valid_position = test_position(spider.position)
	spider.arise()
	
func test_position(position : Vector2):
	var cell_coord = tilemap.world_to_map(position)
	var cell_type_id = tilemap.get_cellv(cell_coord)
	var ground_or_sand = (cell_type_id == tilemap.tile_set.find_tile_by_name("GROUND")) 
	
	return ground_or_sand
	
func randomPoint(cave):
	var point = Util.choose(cave)
	return point
	
func _ready():
	tilemap = get_tree().root.get_node("Main/TileMap")
	var caves = tilemap.caves
	
	for cave in caves:
		for i in range(start_spider):
			instance_spider(cave)

	spider_count = start_spider
			
	


func _on_Timer_timeout():
	tilemap = get_tree().root.get_node("Main/TileMap")
	var caves = tilemap.caves
	if(spider_count < max_spider):
		for cave in caves:
			for i in range(max_spider):
				instance_spider(cave)
				spider_count += 1
				
func _on_Spider_death():
	spider_count = spider_count - 1
	
