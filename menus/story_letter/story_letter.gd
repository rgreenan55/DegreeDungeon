extends Control

@onready var animation_player = %AnimationPlayer

signal s_accepted

func _ready():
	$CanvasLayer/Control.visible = false

func _on_show_story(story_text, title):
	$CanvasLayer/Control.visible = true
	$CanvasLayer/Control/BodyLabel.text = story_text
	$CanvasLayer/Control/TitleLabel.text = title
	animation_player.play("Spin_In")

func _on_degree_accept_button_pressed():
	# The player has chosen to accept their degree, starting the game!
	animation_player.play_backwards("Spin_In")
	await animation_player.animation_finished
	$CanvasLayer/Control.visible = false
	s_accepted.emit()
