extends ColorRect



func _on_Player_player_stats_changed(player):
	$Label.text = "Amount\n"+ str(player.key_amount)
