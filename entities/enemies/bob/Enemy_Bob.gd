extends CharacterBody2D

# References
@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@export var orb_template : PackedScene
# Enums
enum EnemyStates { IDLE, ALERT }

# Variables
var move_speed : float
var health : int
var state : EnemyStates
var player : Node2D
var knockback : Vector2

# On Enemy Load
func _ready():
	move_speed = 40
	health = 2
	state = EnemyStates.IDLE
	knockback = Vector2.ZERO
	handle_idle_movement()

# Processes
func _process(_delta):
	if(health <= 0): die()
	play_animations()

# Processes Physics
func _physics_process(_delta):
	#if (state == EnemyStates.ALERT): handle_alert_movement()
	#keep_enemy_in_bounds()
	move_and_slide()

# Movement when Enemy is IDLE
func handle_idle_movement():
	if (state == EnemyStates.IDLE):
		velocity = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized() * move_speed
		$MovementTimer.start(randf_range(1,3))
# Handles Animations
func play_animations():
	if (velocity.x == 0):
		if (velocity.y < 0): animation.play("move_up")
		elif (velocity.y > 0): animation.play("move_down")
		else: animation.play("idle")
	else:
		if (velocity.x < 0): animation.play("move_left");
		elif (velocity.x > 0): animation.play("move_right")

func keep_enemy_in_bounds():
	var screen_size = get_viewport_rect().size
	if position.x < 0:
		position.x = 0
		velocity.x *= -1
	if position.x > screen_size.x :
		position.x = screen_size.x
		velocity.x *= -1
	if position.y < 0:
		position.y = 0
		velocity.y *= -1
	if position.y > screen_size.y:
		position.y = screen_size.y
		velocity.y *= -1

func handle_hit():
	health -= 1
	$HurtSound.playing = true

func die():
	$DeathSound.playing = true
	queue_free()

func _on_movement_timer_timeout():
	handle_idle_movement()

func _on_shoot_timer_timeout():
	var orb = orb_template.instantiate()
	add_child(orb)
	$AttackSound.playing = true
