extends Control
class_name TITLE_MENU

@export var starting_scene : PackedScene
@onready var scene_transition = $SceneTransition

# Start the game at the scene specified in starting_scene
func _on_play_pressed():
	GameState.current_scene = starting_scene.resource_path
	scene_transition.transition_to(GameState.current_scene)

# Quit out of the game
func _on_quit_pressed():
	get_tree().quit()
