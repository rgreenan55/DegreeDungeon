extends Node2D

@onready var exits = $Exits

var room_cleared: bool = false

var random_drop = preload("res://entities/items/objects/GenericDrop.tscn")

var last_enemy_pos: Vector2 = Vector2.ZERO

signal s_next_level
signal s_enable_player
signal s_disable_follow_camera
signal s_enable_ui
signal s_play_audio(audio_name)

func _ready():
	s_enable_player.emit()
	s_enable_ui.emit()
	s_disable_follow_camera.emit()

func _process(_delta):
	# TODO: Remove this in final product
	if Input.is_action_just_pressed("dev_kill_all"):
		for enemy in get_tree().get_nodes_in_group("Enemy"):
			enemy.queue_free()
	if !room_cleared:
		_check_room_clear()
	else:
		exits._on_enemy_died()

func _check_room_clear():
	room_cleared = get_tree().get_nodes_in_group("Enemy").size() <= 0
	if room_cleared:
		_spawn_powerup()
		GameState.scene_cleared()
	else:
		last_enemy_pos = get_tree().get_nodes_in_group("Enemy")[0].position

func _spawn_powerup():
	if random_drop:
		var powerup_instance = random_drop.instantiate()
		powerup_instance.position = last_enemy_pos
		powerup_instance.s_picked_up.connect(_play_drinking_noise)
		add_child(powerup_instance)

func _play_drinking_noise():
	s_play_audio.emit("Drinking")

func _transition_level():
	s_next_level.emit()
