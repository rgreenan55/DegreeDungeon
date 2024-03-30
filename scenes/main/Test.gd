extends Node2D

signal s_enable_player
signal s_enable_ui

func _ready():
	s_enable_player.emit()
	s_enable_ui.emit()
