extends CharacterBody2D

# Character Model from: https://limezu.itch.io/moderninteriors

# References
@onready var animation : AnimatedSprite2D = $AnimatedSprite

# Variables
var move_speed : float

# On Player Load
func _ready():
	move_speed = 200
	velocity = Vector2.ZERO

# Regular Processes
func _process(delta):
	get_movement_input()
	determine_animation()

# Physics Processes
func _physics_process(delta):
	move_and_slide()

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


