extends ColorRect



func _on_Player_player_stats_changed(var player):
	$Label.text = "Amount\n"+ str(player.health_potions)
