extends Control

@onready var animation_player = %AnimationPlayer

signal s_next_level

func _ready():
	animation_player.play("Spin_In")
	$LetterSound.playing = true

func _on_degree_accept_button_pressed():
	# The player has chosen to accept their degree, starting the game!
	animation_player.play_backwards("Spin_In")
	$AcceptSound.playing = true
	await animation_player.animation_finished
	s_next_level.emit() 

func _on_degree_deny_button_pressed():
	# If the player has denied the acceptance letter,
	# then they can just roam around their house indefinetly
	animation_player.play_backwards("Spin_In")
