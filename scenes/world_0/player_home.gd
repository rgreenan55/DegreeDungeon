extends Node2D


@onready var player = $Player
@onready var player_camera = $PlayerCamera

func _ready():
	_update_camera_pos()

func _process(delta):
	_update_camera_pos()

func _update_camera_pos():
	player_camera.position.x = player.position.x
	player_camera.position.y = player.position.y
	# player_camera.position = clamp(player_camera.position, Vector2(0, 0), Vector2(1152, 648))
