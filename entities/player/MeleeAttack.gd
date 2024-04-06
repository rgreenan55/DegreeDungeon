extends Area2D

@onready var animation : AnimationPlayer = $AnimationPlayer

var force = 200
var lastUsed = 0
var delay = 1

func _process(delta):
	determine_position()
	lastUsed -= delta

func determine_position():
	look_at(get_global_mouse_position())
	#var global_position.angle_to(get_global_mouse_position())

func attack():
	if lastUsed < 0:
		animation.play("attack")
		$"../AttackSound".playing = true
		lastUsed = delay 

func _on_body_entered(body):
	if (body.has_method("handle_hit")):
		body.knockback = $"..".global_position.direction_to(body.global_position) * force
		body.handle_hit()
