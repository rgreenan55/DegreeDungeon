extends Node2D

signal s_transition_room

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		s_transition_room.emit()

func _disable_collision():
	$Area2D/CollisionShape2D.disabled = true

func _enable_collision():
	$Area2D/CollisionShape2D.disabled = false
