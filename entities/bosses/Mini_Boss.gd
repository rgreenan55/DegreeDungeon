extends CharacterBody2D

# References
@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D
# Enums
enum EnemyStates { IDLE, ALERT }

# Signals
signal died
signal s_damaged

# Variables
@export var attack : bool
@export var projectile_template : PackedScene
var death : bool
var move_speed : float
var max_health: int = 2
var current_health : int
var state : EnemyStates
var player : Node2D
var knockback : Vector2
var range : bool

# On Enemy Load
func _ready():
	move_speed = 30
	current_health = max_health
	knockback = Vector2.ZERO
	state = EnemyStates.IDLE
	handle_idle_movement()
	attack = false
	death = false
	range = false

# Processes
func _process(_delta):
	if (current_health <= 0):
		$ShootTimer.autostart = false
		$ShootTimer.stop()
		death = true
	if (!range && current_health < 10):
		switch_to_range()
	play_animations()

# Processes Physics
func _physics_process(delta):
	if (death):
		velocity = Vector2.ZERO
	else:
		if (state == EnemyStates.ALERT): handle_alert_movement()
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
		animation.animation_looped.connect(die)
	elif (velocity.x == 0):
		if (velocity.y < 0):
			animation.play("move")
		elif (velocity.y > 0):
			animation.play("move")
		else: animation.play("idle")
	else:
		animation.play("move")
		if (velocity.x < 0): animation.flip_h = true
		else: animation.flip_h = false

func handle_hit():
	current_health -= 1
	if (current_health <= 0): $DeathSound.play()
	else: $HurtSound.play()
	$AnimatedSprite2D/AnimationPlayer.play("on_hit")
	s_damaged.emit()

func die():
	died.emit()
	queue_free()

#turns off attack animation if not in player body
func _on_hurt_box_body_exited(body):
	if body.is_in_group("Player"):
		attack = false

#turn on ranged capabilities
func switch_to_range():
	range = true
	move_speed = 40
	$ShootTimer.start()
	$ShootTimer.autostart = true

#spawn projectile on shoot timer timeout
func _on_shoot_timer_timeout():
	if((randi_range(1,10) > 3) and !$HurtSound.playing and !$MeleeSound.playing and !$IdleSound.playing): $ShootSound.play()
	var projectile = projectile_template.instantiate()
	add_child(projectile)

#to play melee sound
func _on_hurt_box_body_entered(body):
	if(!$HurtSound.playing and !$ShootSound.playing and !$IdleSound.playing): $MeleeSound.play()

#50% chance to play idle sounds when exiting line of sight
func _on_line_of_sight_body_exited(body):
	if(!$ShootSound.playing and (randi_range(1,99) > 50) and !$MeleeSound.playing and !$HurtSound.playing): $IdleSound.play()
