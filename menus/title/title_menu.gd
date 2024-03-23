extends Control
class_name TITLE_MENU

@onready var scene_transition = $SceneTransition

func _ready():
	# Reset the game state variables
	GameState.reset()

# Start the game at the next scene specified in Year 0 
func _on_play_pressed():
	scene_transition.transition_to(GameState.next_scene_path())

# Quit out of the game
func _on_quit_pressed():
	get_tree().quit()
