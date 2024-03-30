extends Node2D

signal s_next_level
signal s_enable_player
signal s_enable_ui
signal s_disable_follow_camera

func _ready():
	s_enable_player.emit()
	s_enable_ui.emit()
	s_disable_follow_camera.emit()

func _on_room_transition_s_transition_room():
	s_next_level.emit()
