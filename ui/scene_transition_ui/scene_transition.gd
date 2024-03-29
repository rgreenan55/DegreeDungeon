extends Control

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play_backwards("Fade")

func transition_to(scene: String) -> void:
	animation_player.play("Fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(scene)
