extends CharacterBody2D

# References
@onready var animation : AnimatedSprite2D = $AnimatedSprite
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D

# Enums
enum EnemyStates { IDLE, ALERT }

# Signals
signal died

# Variables
var move_speed : float
var health : int
var state : EnemyStates
var player : Node2D
var knockback : Vector2

var timeSinceLastSound = 0
var nextSoundTime = 3+(1+randf()*3)
# On Enemy Load
func _ready():
	move_speed = 30
	health = 3
	knockback = Vector2.ZERO
	state = EnemyStates.IDLE
	handle_idle_movement()

# Processes
func _process(delta):
	timeSinceLastSound += delta
	if (health == 0): die()
	playSound()
	play_animations()

# Processes Physics
func _physics_process(_delta):
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
		move_speed = 60
		state = EnemyStates.ALERT

# Handles Animations
func play_animations():
	if (velocity.x == 0):
		if (velocity.y < 0): animation.play("move_up")
		elif (velocity.y > 0): animation.play("move_down")
		else: animation.play("idle")
	else:
		animation.play("move_left_right");
		if (velocity.x < 0): animation.flip_h = true
		else: animation.flip_h = false

func genRandomTime():
	nextSoundTime = 3+(1+randf()*3)

func playSound():
	if nextSoundTime < timeSinceLastSound:
		timeSinceLastSound = 0
		genRandomTime()
		if state == EnemyStates.ALERT:
			$ChaseSound.playing = true
		else:
			$IdleSound.playing = true

func handle_hit():
	health -= 1
	$HurtSound.playing = true

func die():
	died.emit()
	$DeathSound.playing = true
	$DeathSound.reparent(get_parent())
	# Death Animation
	queue_free()
