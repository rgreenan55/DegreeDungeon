extends Node2D

signal s_exit_door

func _disable_collision():
	$RoomTransition._disable_collision()
	
func _enable_collision():
	$RoomTransition._enable_collision()

func _on_room_transition_s_transition_room():
	s_exit_door.emit()
