extends CharacterBody2D

# References
@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D
# Enums
enum EnemyStates { IDLE, ALERT }

# Signals
signal died

# Variables
@export var attack : bool
@export var projectile_template : PackedScene
var death : bool
var move_speed : float
var health : int
var state : EnemyStates
var player : Node2D
var knockback : Vector2
var range : bool 

# On Enemy Load
func _ready():
	move_speed = 30
	health = 20
	knockback = Vector2.ZERO
	state = EnemyStates.IDLE
	handle_idle_movement()
	attack = false
	death = false
	range = false

# Processes
func _process(_delta):
	print(move_speed)
	if (health == 0): death = true
	if (health == 10): 
		switch_to_range()
	play_animations()

# Processes Physics
func _physics_process(delta):
	if (state == EnemyStates.ALERT): handle_alert_movement()
	#keep_enemy_in_bounds()
	velocity = velocity + knockback
	knockback = lerp(knockback, Vector2.ZERO, 0.1)
	move_and_slide()

# Move Towards Next Navigation Point
func handle_alert_movement():
	make_path()
	velocity = to_local(nav_agent.get_next_path_position()).normalized() * move_speed

# Creates Path for Navigation (called on Timer End)
func make_path():
	nav_agent.target_position = player.global_position
	$PathFindingTimer.start()

# Movement when Enemy is IDLE
func handle_idle_movement():
	if (state == EnemyStates.IDLE):
		velocity = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized() * move_speed
		$MovementTimer.start(randf_range(2,5))

# Called when player enters enemy Line Of Sight
func enemy_sees_player(body : Node2D):
	if (body.is_in_group("Player")):
		$MovementTimer.paused = true
		$PathFindingTimer.start()
		player = body
		if range: move_speed = 40
		else: move_speed = 60
		state = EnemyStates.ALERT

# Handles Animations
func play_animations():
	if attack:
		animation.play("attack")
	elif death:
		animation.play("die")
		die()
	elif (velocity.x == 0):
		if (velocity.y < 0): 
			animation.play("move")
		elif (velocity.y > 0): 
			animation.play("move")
		else: animation.play("idle")
	else:
		animation.play("move");
		if (velocity.x < 0): animation.flip_h = true
		else: animation.flip_h = false
		

#func keep_enemy_in_bounds():
	#var screen_size = get_viewport_rect().size
	#if position.x < 0:
		#position.x = 0
		#velocity.x *= -1
	#if position.x > screen_size.x:
		#position.x = screen_size.x
		#velocity.x *= -1
	#if position.y < 0:
		#position.y = 0
		#velocity.y *= -1
	#if position.y > screen_size.y:
		#position.y = screen_size.y
		#velocity.y *= -1

func handle_hit():
	health -= 1

func die():
	died.emit()
	queue_free()

func _on_hurt_box_body_exited(body):
	if body.is_in_group("Player"):
		attack = false

func switch_to_range():
	range = true
	move_speed = 40
	$ShootTimer.start()
	$ShootTimer.autostart = true

func _on_shoot_timer_timeout():
	var projectile = projectile_template.instantiate()
	add_child(projectile)

