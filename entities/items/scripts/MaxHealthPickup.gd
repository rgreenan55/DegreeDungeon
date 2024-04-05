extends Node2D

signal picked_up

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.max_health += 1
		body.current_health = body.max_health
		body.s_max_health_changed.emit(body.max_health)
		picked_up.emit()
		queue_free()
