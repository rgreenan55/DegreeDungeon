extends CharacterBody2D

# References
@onready var animation : AnimatedSprite2D = $AnimatedSprite
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D

# Enums
enum EnemyStates { IDLE, ALERT }

# Variables
var move_speed : float
var health : int
var state : EnemyStates
var player : Node2D

# On Enemy Load
func _ready():
	move_speed = 50
	health = 3
	state = EnemyStates.IDLE
	handle_idle_movement()

# Processes
func _process(_delta):
	play_animations()

# Processes Physics
func _physics_process(_delta):
	if (state == EnemyStates.ALERT): handle_alert_movement()
	keep_enemy_in_bounds()
	move_and_slide()

# Move Towards Next Navigation Point
func handle_alert_movement():
	velocity = to_local(nav_agent.get_next_path_position()).normalized() * move_speed

# Creates Path for Navigation (called on Timer End)
func make_path():
	nav_agent.target_position = player.global_position
	$PathFindingTimer.start()

# Movement when Enemy is IDLE
func handle_idle_movement():
	if (state == EnemyStates.IDLE):
		velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * move_speed
		$MovementTimer.start(randf_range(2,5))

# Called when player enters enemy Line Of Sight
func enemy_sees_player(body : Node2D):
	if (body.is_in_group("Player")):
		$MovementTimer.paused = true
		$PathFindingTimer.start()
		player = body
		move_speed = 75
		state = EnemyStates.ALERT

# Handles Animations
func play_animations():
	if (velocity.x == 0):
		if (velocity.y < 0): animation.play("move_up")
		elif (velocity.y > 0): animation.play("move_down")
		else: animation.play("idle")
	else:
		animation.play("move");
		if (velocity.x < 0): animation.flip_h = true
		else: animation.flip_h = false

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
