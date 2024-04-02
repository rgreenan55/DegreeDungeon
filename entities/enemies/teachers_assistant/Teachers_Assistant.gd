extends CharacterBody2D

# References
@onready var animation : AnimatedSprite2D = $AnimatedSprite

# Signals
signal died

# Variables
var move_speed : float
var health : int
var knockback : Vector2

# On Enemy Load
func _ready():
	move_speed = 30
	health = 20
	knockback = Vector2.ZERO

# Processes
func _process(_delta):
	if (health == 0): die()
	play_animations()

# Processes Physics
func _physics_process(delta):
	velocity = velocity + knockback
	knockback = lerp(knockback, Vector2.ZERO, 0.1)
	move_and_slide()

# Movement
func handle_movement():
	velocity = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized() * move_speed
	$MovementTimer.start(randf_range(1,3))

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

func handle_hit():
	health -= 1

func die():
	died.emit()
	# Death Animation
	queue_free()
