extends CanvasLayer

@onready var animation_player = %AnimationPlayer

signal s_restart_level
signal s_quit_game

func _ready():
	animation_player.play("Game_Over_Appear")

func _on_restart_pressed():
	animation_player.play_backwards("Game_Over_Appear")
	await animation_player.animation_finished
	s_restart_level.emit()
	
func _on_quit_pressed():
	s_quit_game.emit()
