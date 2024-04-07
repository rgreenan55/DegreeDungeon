extends CanvasLayer

@onready var animation_player = $Control/AnimationPlayer

func display_degree():

	animation_player.play("Degree_Spin_In")
	await animation_player.animation_finished
	animation_player.play_backwards("Degree_Spin_In")
	await animation_player.animation_finished
