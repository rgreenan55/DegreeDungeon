extends CharacterBody2D

@onready var animation : AnimatedSprite2D = $AnimatedSprite

# Variables
var speed = 50  # Adjust as needed
var health = 100
var move_timer = 2
var stop_timer = 1
var move = false

func _ready():
	random_movement()

func _process(delta):
	if move:
		move_and_slide()
		keep_enemy_in_bounds()
		play_animations()
	
		move_timer -= delta
		if move_timer <= 0:
			move = false
	else:
		velocity = Vector2.ZERO 
		play_animations()
		stop_timer -= delta
		if stop_timer <= 0:
			random_movement()

#randomly move player every few seconds
func random_movement():
	velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * speed
	move_timer = randf_range(2,5)
	move = true
	stop_timer = 1

#play enemy animations
func play_animations():
	if (velocity.x == 0):
		if (velocity.y < 0): animation.play("move_up")
		elif (velocity.y > 0): animation.play("move_down")
		else: animation.play("idle") 
	else:
		animation.play("move");
		if (velocity.x < 0): animation.flip_h = true
		else: animation.flip_h = false

#make sure enemy doesn't go out of screen
func keep_enemy_in_bounds():
	var screen_size = get_viewport_rect().size
	if position.x < 0:
		position.x = 0
		velocity.x *= -1
	if position.x > screen_size.x:
		position.x = screen_size.x
		velocity.x *= -1
	if position.y < 0:
		position.y = 0
		velocity.y *= -1
	if position.y > screen_size.y:
		position.y = screen_size.y
		velocity.y *= -1
	

func die():
	queue_free()
