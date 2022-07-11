extends Area2D

var tilemap
var speed = 500
var direction : Vector2
var attack_damage1 = 50
var attack_damage2 = 60
var attack_damage3 = 60
var attack_damage4 = 60

func _ready():
	tilemap = get_tree().root.get_node("Main/TileMap")
	var animation
	if(get_animation_direction(direction) == "left"):
		animation = "right_fly"
		$AnimatedSprite.flip_h = true
	else:
		animation = get_animation_direction(direction) + "_fly"
	$AnimatedSprite.play(animation)

func _process(delta):
	position = position + speed * delta * direction
	


func _on_Bullet_body_entered(body):
	
	if body.name == "Player":
		return
	
	if body.name == "TileMap":
		var cell_coord = tilemap.world_to_map(position)
		var cell_type_id = tilemap.get_cellv(cell_coord)
		if cell_type_id == tilemap.tile_set.find_tile_by_name("Water"):
			return
	if body.name.find("Immortal_Spider") >= 0:
		body.hit(attack_damage1)
		direction = Vector2.ZERO
		get_tree().queue_delete(self)
	if body.name.find("Red-Spider") >= 0:
		body.hit(attack_damage3)
		direction = Vector2.ZERO
		get_tree().queue_delete(self)
	if body.name.find("Speed_Spider") >= 0:
		body.hit(attack_damage4)
		direction = Vector2.ZERO
		get_tree().queue_delete(self)
	if body.name.find("Poison_Spider") >= 0:
		body.hit(attack_damage2)
		direction = Vector2.ZERO
		get_tree().queue_delete(self)
	
	


func _on_AnimatedSprite_animation_finished():
	var animation
	if direction != Vector2.ZERO:
		if(get_animation_direction(direction) == "left"):
			animation = "right_explode"
			$AnimatedSprite.flip_h = true
		else:
			animation = get_animation_direction(direction) + "_explode"
	#	
		$AnimatedSprite.play(animation)
	direction = Vector2.ZERO


func _on_Timer_timeout():
	if $AnimatedSprite.animation.ends_with("_explode"):
		get_tree().queue_delete(self)
		
func get_animation_direction(direction : Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.y >= 0.707:
		return "down"
	elif norm_direction.y <= -0.707:
		return "up"
	elif norm_direction.x <= -0.707:
		return "left"
	elif norm_direction.x >= 0.707:
		return "right"
	return "down"
