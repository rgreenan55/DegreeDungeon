extends Node2D

@onready var ui = %UI
@onready var current_scene = %CurrentScene
@onready var current_menu = %CurrentMenu
@onready var animation_player = $SceneTransition/AnimationPlayer

var scene_instance: PackedScene
var menu_instance: PackedScene

func _ready():
	_disable_ui()
	_disable_player()
	GameState.reset()
	_load_menu(GameState.main_menu)
	await _transition_out()
	
func _disable_ui():
	ui.visible = false
	
func _enable_ui():
	ui.visible = true
	
func _disable_player():
	pass
	
func _enable_player():
	pass
	
func _next_level():
	await _transition_into()
	_load_scene(GameState.next_scene_path())
	await _transition_out()
	
func _quit_game():
	get_tree().quit()
	
func _transition_into():
	animation_player.play("Transition_Fade_In")
	return animation_player.animation_finished
	
func _transition_out():
	animation_player.play_backwards("Transition_Fade_In")
	return animation_player.animation_finished
	
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
		current_menu.add_child(new_instance)

func _unload_scene():
	if is_instance_valid(scene_instance):
		scene_instance.queue_free()
	scene_instance = null

func _load_scene(scene_path: String):
	_unload_menu()
	_unload_scene()
	scene_instance = load(scene_path)
	if scene_instance:
		current_scene.add_child(scene_instance.instantiate())
