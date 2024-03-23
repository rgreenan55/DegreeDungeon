extends Area2D

@onready var animation : AnimationPlayer = $AnimationPlayer

var force = 200

func _process(delta):
	determine_position()

func determine_position():
	look_at(get_global_mouse_position())
	#var global_position.angle_to(get_global_mouse_position())

func attack():
	animation.play("attack")

func _on_body_entered(body):
	if (body.has_method("handle_hit")):
		body.knockback = $"..".global_position.direction_to(body.global_position) * force
		body.handle_hit($".")
