extends Control
class_name TITLE_MENU

@export var starting_scene : PackedScene

# Start the game at the scene specified in starting_scene
func _on_play_pressed():
	get_tree().change_scene_to_packed(starting_scene)

# Quit out of the game
func _on_quit_pressed():
	get_tree().quit()
