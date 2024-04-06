extends Node2D

@onready var ui = %UI
@onready var player = %Player
@onready var follow_camera = %FollowCamera
@onready var current_scene = %CurrentScene
@onready var current_menu = %CurrentMenu
@onready var animation_player = $SceneTransition/AnimationPlayer
@onready var audio_player = %AudioPlayer

var scene_instance: PackedScene
var menu_instance: PackedScene

func _ready():
	_init_player()
	_init_ui()
	_disable_player()
	_disable_ui()
	_disable_follow_camera()
	GameState.reset()
	_load_menu(GameState.get_menu_path("title_menu"))
	await _transition_out()

func _process(_delta):
	if follow_camera.enabled:
		follow_camera.position = player.position

#########################################
#	Functions for managing parts of
# 	the Main scene
#########################################
func _disable_ui():
	ui.visible = false

func _enable_ui():
	ui.visible = true

func _init_ui():
	ui.set_max_health(player.max_health)
	ui.update_health(player.current_health)

func _disable_player():
	player.visible = false;

func _enable_player():
	player.visible = true;

func _init_player():
	player.current_health = player.max_health - 1
	player.s_health_changed.connect(ui.update_health)
	player.s_died.connect(func(): _display_menu("game_over"))

func _enable_follow_camera():
	follow_camera.enabled = true

func _disable_follow_camera():
	follow_camera.enabled = false;

#########################################
#	General functions that are called
# 	through signals by the currently
# 	active scene and menu.
#########################################
func _play_audio(audio_name: String):
	for audio in audio_player.get_children():
		if audio.name == audio_name:
			audio.playing = true

func _display_menu(menu_name: String):
	_load_menu(GameState.get_menu_path(menu_name))

func _next_level():
	await _transition_into()
	_load_scene(GameState.next_scene_path())
	player.position = GameState.player_starting_position()
	await _transition_out()

func _restart_current_year():
	await _transition_into()
	_load_scene(GameState.start_of_year())
	player._ready()
	ui.update_health(player.current_health)
	player.position = GameState.player_starting_position()
	await _transition_out()

func _quit_game():
	get_tree().quit()

func _transition_into():
	animation_player.play("Transition_Fade_In")
	return animation_player.animation_finished

func _transition_out():
	animation_player.play_backwards("Transition_Fade_In")
	return animation_player.animation_finished

#########################################
#	Scene and Menu management functions
#########################################
func _unload_menu():
	if is_instance_valid(menu_instance):
		current_menu.get_child(0).queue_free()
	menu_instance = null

func _load_menu(menu_path: String):
	_unload_menu()
	menu_instance = load(menu_path)
	if menu_instance:
		var new_instance = menu_instance.instantiate()
		if new_instance.has_signal("s_next_level"):
			new_instance.s_next_level.connect(_next_level)
		if new_instance.has_signal("s_quit_game"):
			new_instance.s_quit_game.connect(_quit_game)
		if new_instance.has_signal("s_restart_level"):
			new_instance.s_restart_level.connect(_restart_current_year)
		current_menu.add_child(new_instance)

func _unload_scene():
	if is_instance_valid(scene_instance):
		current_scene.get_child(0).queue_free()
	scene_instance = null

func _load_scene(scene_path: String):
	_unload_menu()
	_unload_scene()
	scene_instance = load(scene_path)
	if scene_instance:
		var new_instance = scene_instance.instantiate()
		if new_instance.has_signal("s_show_menu"):
			new_instance.s_show_menu.connect(_display_menu)
		if new_instance.has_signal("s_play_audio"):
			new_instance.s_play_audio.connect(_play_audio)
		if new_instance.has_signal("s_next_level"):
			new_instance.s_next_level.connect(_next_level)
		if new_instance.has_signal("s_enable_player"):
			new_instance.s_enable_player.connect(_enable_player)
		if new_instance.has_signal("s_disable_player"):
			new_instance.s_disable_player.connect(_disable_player)
		if new_instance.has_signal("s_enable_ui"):
			new_instance.s_enable_ui.connect(_enable_ui)
		if new_instance.has_signal("s_disable_ui"):
			new_instance.s_disable_ui.connect(_disable_ui)
		if new_instance.has_signal("s_enable_follow_camera"):
			new_instance.s_enable_follow_camera.connect(_enable_follow_camera)
		if new_instance.has_signal("s_disable_follow_camera"):
			new_instance.s_disable_follow_camera.connect(_disable_follow_camera)
		current_scene.add_child(new_instance)
