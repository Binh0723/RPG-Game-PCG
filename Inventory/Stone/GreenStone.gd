extends Area2D

enum STONE {BlackStone, RedStone, BlueStone, GreenStone}
export(STONE) var type = STONE.GreenStone

func _on_GreenStone_body_entered(body):
	if(body.name == "Player"):
		get_tree().queue_delete(self)

		body.add(type)
