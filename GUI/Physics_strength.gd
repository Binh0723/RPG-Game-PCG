extends ColorRect

func _on_Player_player_stats_changed(var player):
	$Bar.rect_size.x = 298 * player.physics_strength / player.max_physics_strength
