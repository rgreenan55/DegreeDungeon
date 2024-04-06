extends Node2D

signal picked_up

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if body.max_health > body.current_health:
			body.current_health += 1
			body.s_health_changed.emit(body.current_health)
			picked_up.emit()
			queue_free()
