
extends KinematicBody2D

export var speed = 100
signal player_stats_changed

var last_direction = Vector2(0,1)
var attack_playing = false

var punch_cooldown_time = 500
var shoot_cooldown_time = 1500
var sword_cooldown_time = 1000

var next_shoot_time = 0
var next_punch_time = 0
var next_sword_time = 0

var max_physics_strength = 100
var physics_strength = 100
var physics_strength_regeneration = 2 

var max_health = 100
var health_regeneration = 2
var health = 100

var punch_damage = 20
var sword_damage = 30
var bullet_damage = 50

enum Potion { HEALTH, MANA }
var health_potions = 0
var mana_potions = 0

enum STONE {BlackStone, RedStone, BlueStone, GreenStone}
var red_stone_amount = 0
var blue_stone_amount = 0
var green_stone_amount = 0
var black_stone_amount = 0

var shoot_scene = preload("res://Enitities/Bullet/Bullet.tscn")

func _ready():
	$AnimationPlayer.current_animation = "Hit"
	emit_signal("player_stats_changed", self)

#movement of the player for each frame
func _physics_process(delta):
	var direction : Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
		
	var movement = speed * delta * direction
	move_and_collide(movement)
	if not attack_playing:
		animates_player(direction)
	if direction != Vector2.ZERO:
		$RayCast2D.cast_to = direction.normalized() * 15
	
	
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
	
func animates_player(direction: Vector2):
	$AnimatedSprite.flip_h = false
	var animation

	if direction != Vector2.ZERO:
		last_direction = direction
		if(get_animation_direction(last_direction) == "left"):
			animation = "right_walk"
			$AnimatedSprite.flip_h = true
		else:
			animation = get_animation_direction(last_direction) + "_walk"
		# Play the walk animation
		
		$AnimatedSprite.play(animation)
	else:
		
		if(get_animation_direction(last_direction) == "left"):
			animation = "right_idle"
			$AnimatedSprite.flip_h = true
		else:
			animation = get_animation_direction(last_direction) + "_idle"
			
		$AnimatedSprite.play(animation)

	
func _input(event):

	var animation
	if event.is_action_pressed("punch"):
		var now = OS.get_ticks_msec()
		if now >= next_punch_time && physics_strength > 5:
			var target = $RayCast2D.get_collider()
			if target!= null and target.name != "TileMap" and target.name != "Portal":
				if target.name.find("Immortal_Spider") || \
				target.name.find("Speed_Spider") || \
				target.name.find("Red_Spider") || \
				target.name.find("Poison_Spider"):
					target.hit(punch_damage)
			attack_playing = true
			if(get_animation_direction(last_direction) == "left"):
				animation = "right_punch"
				$AnimatedSprite.flip_h = true

			else:
				animation = get_animation_direction(last_direction) + "_punch"

			$AnimatedSprite.play(animation)
			physics_strength = physics_strength - 5
			emit_signal("player_stats_changed",self)
			next_punch_time = now + punch_cooldown_time
			
	elif event.is_action_pressed("sword"):
		var now = OS.get_ticks_msec()
		if now >= next_sword_time && physics_strength > 5:
			var target = $RayCast2D.get_collider()
			if target!= null and target.name != "TileMap" and target.name != "Portal":
				if target.name.find("Immortal_Spider") || \
				target.name.find("Speed_Spider") || \
				target.name.find("Red_Spider") || \
				target.name.find("Poison_Spider"):
					target.hit(sword_damage)
			attack_playing = true
			
			if(get_animation_direction(last_direction) == "left"):
				animation = "right_sword"
				$AnimatedSprite.flip_h = true
			else:
				animation = get_animation_direction(last_direction) + "_sword"
			$AnimatedSprite.play(animation)
			physics_strength = physics_strength - 5
			emit_signal("player_stats_changed",self)
			next_sword_time = now + sword_cooldown_time
			
	elif event.is_action_pressed("shoot"):
		var now = OS.get_ticks_msec()
		if now >= next_shoot_time:
			attack_playing = true
			if(get_animation_direction(last_direction) == "left"):
				animation = "right_shoot"
				$AnimatedSprite.flip_h = true
			else:
				animation = get_animation_direction(last_direction) + "_shoot"			
			$AnimatedSprite.play(animation)
			next_shoot_time = now + shoot_cooldown_time


func _on_AnimatedSprite_animation_finished():
	attack_playing = false
	if $AnimatedSprite.animation.ends_with("_shoot"):
		var shoot = shoot_scene.instance()
		shoot.direction = last_direction.normalized()
		shoot.position = position + last_direction.normalized() * 10
		get_parent().add_child(shoot)

func _process(delta):
	var new_physics_strength = min(physics_strength + physics_strength_regeneration * delta,max_physics_strength)
	if new_physics_strength != physics_strength:
		physics_strength = new_physics_strength
		emit_signal("player_stats_changed",self)
	var new_health = min(health + health_regeneration * delta, max_health)
	if new_health != health:
		health = new_health
		emit_signal("player_stats_changed", self)
		
func hit(damage):
	health -= damage
	emit_signal("player_stats_changed",self)
	if health <= 0:
		pass
	else:
		$AnimationPlayer.play("Hit")

func add_potion(type):
	if type == Potion.HEALTH:
		health_potions = health_potions + 1
	elif type == Potion.MANA:
		mana_potions = mana_potions + 1
	elif type == STONE.BlackStone:
		black_stone_amount = black_stone_amount + 1
	elif type == STONE.RedStone:
		black_stone_amount = black_stone_amount + 1
	elif type == STONE.BlueStone:
		black_stone_amount = black_stone_amount + 1
	elif type == STONE.GreenStone:
		black_stone_amount = black_stone_amount + 1
	emit_signal("player_stats_changed", self)
	
	
