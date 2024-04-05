extends Node2D

@onready var exit_doors = %ExitDoors

signal s_next_level
signal s_enable_player
signal s_enable_ui
signal s_enable_follow_camera

func _ready():
	s_enable_player.emit()
	s_enable_ui.emit()
	s_enable_follow_camera.emit()
	_enable_door(GameState.scenes_cleared)
	
func _enable_door(n_scenes_cleared):
	var active_door_name = "ExitDoor{idx}".format({"idx": n_scenes_cleared + 1})
	for door in exit_doors.get_children():
		if door.name == active_door_name:
			door.visible = true
		else:
			door.visible = false
			door.process_mode = 4
			door.hide()

func _on_exit_door_top_s_exit_door():
	s_next_level.emit()
