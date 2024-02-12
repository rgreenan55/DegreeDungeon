extends CharacterBody2D

# References
@onready var animation : AnimatedSprite2D = $AnimatedSprite

# Variables
var move_speed : float

# On Player Load
func _ready():
	move_speed = 300
	velocity = Vector2.ZERO


func _process(delta):
	pass

# Physics Processes
func _physics_process(delta):
	get_movement_input()
	determine_animation()
	move_and_slide()

func get_movement_input():
	var input_vector : Vector2 = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	velocity = input_vector * move_speed

func determine_animation():
	if (velocity.x == 0):
		if (velocity.y < 0): animation.play("move_up")
		elif (velocity.y > 0): animation.play("move_down")
		else: animation.play("idle")
	else:
		animation.play("move");
		if (velocity.x < 0): animation.flip_h = true
		else: animation.flip_h = false
