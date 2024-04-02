extends Node2D

@onready var exits = $Exits

signal s_next_level
signal s_enable_player
signal s_disable_follow_camera
signal s_enable_ui

func _ready():
	s_enable_player.emit()
	s_enable_ui.emit()
	s_disable_follow_camera.emit()
	
func _process(delta):
	# Goofy way of checking if all the enemies have died
	if get_node("Enemy") == null and get_node("EnemyBob") == null and get_node("Enemy_Turret") == null:
		exits._on_enemy_died()
	
func _transition_level():
	s_next_level.emit()
