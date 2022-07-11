extends Area2D


var Condition_is_met = true
func _on_Portal_body_entered(body):
#	if Condition_is_met:
#
	if body.name == "Player" and Condition_is_met:
		get_tree().change_scene_to(load("res://Maze/Maze.tscn"))
	print(body.name)
