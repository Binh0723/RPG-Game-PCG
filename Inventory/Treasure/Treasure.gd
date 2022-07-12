extends Area2D

signal Completed

func _on_TreasureChest_body_entered(body):
	if body.name == "Player" and body.key_amount > 0:
		$Sprite.play("open")
		$Timer.start()
		
func _on_Timer_timeout():
	get_tree().queue_delete(self)
	emit_signal("Completed")
