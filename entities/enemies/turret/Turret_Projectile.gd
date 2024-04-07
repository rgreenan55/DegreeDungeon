extends Area2D

@export var direction = Vector2.ZERO
var speed = 100

func _process(delta):
	$AnimatedSprite2D.play("projectile")
	position += direction * speed * delta

#decrements the current_health of player if projectile enters player body
#func _on_body_entered(body):
	#print(get_parent())
	#if (body.is_in_group("Player")):
		#body.current_health -= 1
		#var health = body.current_health
		#body.s_health_changed.emit(health)
