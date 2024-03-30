extends Control
class_name TITLE_MENU

signal s_next_level
signal s_quit_game

# Start the game at the next scene specified in Year 0
func _on_play_pressed():
	s_next_level.emit()

# Quit out of the game
func _on_quit_pressed():
	s_quit_game.emit()
