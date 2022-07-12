extends Area2D

enum KEYS {Key =100} 
export(KEYS) var type = KEYS.Key

func _on_Key_body_entered(body):
	if(body.name == "Player"):
		get_tree().queue_delete(self)
		print(type)
		body.add(type)
		print(body.key_amount)
		print(body.name)
