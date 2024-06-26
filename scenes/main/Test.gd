extends Node2D

@onready var exits = $Exits

var room_cleared: bool = false

signal s_next_level
signal s_enable_player
signal s_disable_follow_camera
signal s_enable_ui

func _ready():
	s_enable_player.emit()
	s_enable_ui.emit()
	s_disable_follow_camera.emit()

func _process(_delta):
	if !room_cleared:
		_check_room_clear()
	else:
		exits._on_enemy_died()

func _check_room_clear():
	room_cleared = get_tree().get_nodes_in_group("Enemy").size() <= 0
	if room_cleared:
		GameState.scene_cleared()

func _transition_level():
	s_next_level.emit()
