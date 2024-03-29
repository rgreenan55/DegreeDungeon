extends CanvasLayer
class_name UI

@onready var CoffeeGui = preload("res://ui/player_ui/scenes/coffee_gui.tscn")
@onready var health_container = %HealthContainer
@onready var animation_player = %AnimationPlayer
@onready var scene_transition = %SceneTransition

var health = 5:
	set(new_health):
		health = new_health

func _ready():
	pass

func set_max_health(max_hp : int):
	for i in range(max_hp):
		var coffee = CoffeeGui.instantiate()
		health_container.add_child(coffee)

func update_health(current_health: int):
	if current_health < 0:
		return

	var coffee_cups = health_container.get_children()

	for i in range(current_health):
		coffee_cups[i].update(true)

	for i in range(current_health, coffee_cups.size()):
		coffee_cups[i].update(false)
		
func player_died():
	animation_player.play("Fail_Paper_Spin_In")
	
func send_acceptance_letter():
	animation_player.play("Acceptance_Paper_Spin_In")
	
func _on_restart_pressed():
	animation_player.play_backwards("Fail_Paper_Spin_In")
	await animation_player.animation_finished
	scene_transition.transition_to(GameState.start_of_year())

func _on_quit_pressed():
	get_tree().quit()

func _on_degree_deny_button_pressed():
	# If the player has denied the acceptance letter,
	# then they can just roam around their house indefinetly
	animation_player.play_backwards("Acceptance_Paper_Spin_In")

func _on_degree_accept_button_pressed():
	# The player has chosen to accept their degree, starting the game!
	animation_player.play_backwards("Acceptance_Paper_Spin_In")
	await animation_player.animation_finished
	scene_transition.transition_to(GameState.next_scene_path())
