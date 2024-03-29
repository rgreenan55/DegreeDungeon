extends CharacterBody2D
# Character Model from: https://limezu.itch.io/moderninteriors

# References
@onready var animation : AnimatedSprite2D = $AnimatedSprite
@onready var weapon : Area2D = $MeleeAttack

# Exported Variables
@export var max_health : int = 5

# Variables
var move_speed : float
var is_dead: bool
var is_invincible: bool
var is_speedy: bool

var last_hit_time = 0
var invincibility_frames_duration = 0.5

# Signals
signal s_max_health_changed
signal s_health_changed
signal s_died

var current_health : int :
	set (value):
		if current_health > value and is_invincible:
			return false
		current_health = value
		s_health_changed.emit(value)
		if (value == 0): handle_death()
		start_invincibility_frames()


# On Player Load
func _ready():
	current_health = max_health
	move_speed = 100
	velocity = Vector2.ZERO
	is_dead = false
	is_invincible = false
	is_speedy = false

# Processes
func _process(delta):
	if is_dead:
		return
	get_movement_input()
	determine_animation()
	handle_invincibility_frames(delta)

# Physics Processes
func _physics_process(_delta):
	if is_dead:
		return
	_process_collisions()
	move_and_slide()

func handle_invincibility_frames(delta):
	if last_hit_time != 0:
		last_hit_time -= delta
		if last_hit_time <= 0:
			is_invincible = false
			last_hit_time = 0

func start_invincibility_frames():
	print("invincible")
	is_invincible = true
	last_hit_time = invincibility_frames_duration

#func damage_player(amount):
	#if is_invincible:
		#return
	#current_health -= amount
	#if current_health <= 0:
		#is_dead = true
		#animation.play("dead_left_right");
		#if (velocity.x > 0): animation.flip_h = true
		#s_died.emit()
#
	#s_health_changed.emit(current_health)


func _process_collisions():
	if Input.is_action_just_pressed("dev_dmg"):
		current_health -= 1

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("attack"):
		weapon.attack()


# Determines velocity based on user input
func get_movement_input():
	var input_vector : Vector2 = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	velocity = input_vector * move_speed

# Determines animation of player
func determine_animation():
	if (velocity.x == 0):
		if (velocity.y < 0): animation.play("move_up")
		elif (velocity.y > 0): animation.play("move_down")
		else:
			if (animation.get_animation().begins_with("idle")): pass
			elif (animation.get_animation() == "move_up"): animation.play("idle_up")
			elif (animation.get_animation() == "move_down"): animation.play("idle_down")
			else: animation.play("idle_left_right")
	else:
		animation.play("move_left_right");
		if (velocity.x < 0): animation.flip_h = true
		else: animation.flip_h = false

func handle_hit(body):
	if (body.is_in_group("Enemy") || body.is_in_group("Projectile")):
		current_health -= 1
		s_health_changed.emit(current_health)

func handle_death():
	is_dead = true
	animation.play("dead_left_right");
	if (velocity.x > 0): animation.flip_h = true
	s_died.emit()
