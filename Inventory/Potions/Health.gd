extends Area2D
enum Potion {HEALTH, MANA}
export(Potion) var type = Potion.HEALTH

func _on_Health_body_entered(body):
	if body.name == "Player":
		body.add_potion(type)
		get_tree().queue_delete(self)
