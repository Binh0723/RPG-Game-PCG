extends Area2D

enum TREASURE {GOLD}
export(TREASURE) var type = TREASURE.GOLD

func _on_Gold_body_entered(body):
	if(body.name == "Player"):
		get_tree().queue_delete(self)
		body.add(type)
