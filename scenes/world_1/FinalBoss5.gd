extends "res://scenes/world_1/generic_room_logic.gd"

@onready var health_bar = %HealthBar
@export var beerTemplate: PackedScene

signal s_enable_follow_camera

func _check_room_clear():
	if room_cleared:
		_display_report_card()
		_spawn_powerup()
		GameState.scene_cleared()
		room_cleared = false
		exits._on_enemy_died()
		health_bar.visible = false
		$StoryTimer.start(2.6+2*2.2)
		$DegreeTimer.start(2.6)
		$BeerTimer.start(1)
	elif get_tree().get_nodes_in_group("Enemy").size() > 0:
		last_enemy_pos = get_tree().get_nodes_in_group("Enemy")[0].position

func _on_boss_died():
	print("on boss died function")
	$ReportCard/Control/Sprites/grade_label.text = "Final Grade"
	GameState.scene_cleared()
	room_cleared = true

func _on_boss_first_alert():
	health_bar.initialize($MiniBoss)

func _ready():
	s_enable_player.emit()
	s_enable_ui.emit()
	s_enable_follow_camera.emit()

func _process(_delta):
	# TODO: Remove this in final product
	if Input.is_action_just_pressed("dev_kill_all"):
		$MiniBoss.current_health = 0
	#if !room_cleared:
	_check_room_clear()
	#else:
		#exits._on_enemy_died()


func _on_story_timer_timeout():
	s_show_story_letter.emit(story_for_next_level)
	pass # Replace with function body.
	
func _on_degree_timer_timeout():
	$Degree.display_degree()
	pass # Replace with function body.
	
	
func _on_beer_timer_timeout():
	var beer = beerTemplate.instantiate()
	beer.position.x = 23+randf()*(712-23)
	beer.position.y = 71+randf()*(408-71)
	add_child(beer)
	pass # Replace with function body.
