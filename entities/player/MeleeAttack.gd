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

func _on_hit(thing_hit : Node2D):
	if (thing_hit.has_method("handle_hit")):
		if (thing_hit.is_in_group("Enemy") || thing_hit.is_in_group("MiniBoss")):
			thing_hit.knockback = $"..".global_position.direction_to(thing_hit.global_position) * force
			thing_hit.handle_hit()
		if (thing_hit.is_in_group("Projectile")):
			thing_hit.handle_hit()
