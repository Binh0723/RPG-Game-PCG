extends ColorRect



func _on_Player_player_stats_changed(var player):
	$Bar.rect_size.x = 298 * player.health / player.max_health
