extends "res://scenes/world_1/generic_room_logic.gd"

@export var BossTemplate : PackedScene
@onready var health_bar = %HealthBar

func _check_room_clear():
	if room_cleared:
		_display_report_card()
		_spawn_powerup()
		GameState.scene_cleared()
		room_cleared = false
		exits._on_enemy_died()
		health_bar.visible = false
	elif get_tree().get_nodes_in_group("Enemy").size() > 0:
		last_enemy_pos = get_tree().get_nodes_in_group("Enemy")[0].position

func _on_boss_died():
	print("on boss died function")
	room_cleared = true

func _process(_delta):
	# TODO: Remove this in final product
	if Input.is_action_just_pressed("dev_kill_all"):
		for enemy in get_tree().get_nodes_in_group("Enemy"):
			#enemy.queue_free()
			enemy.current_health = 0
	#if !room_cleared:
	_check_room_clear()
	#else:
		#exits._on_enemy_died()

func _on_paper_picked_up():
	var enemy = BossTemplate.instantiate()
	enemy.add_to_group("Enemy")
	enemy.position.x = 64
	enemy.position.y = 40
	add_child(enemy) #adds as a child of ourselves
	health_bar.initialize(enemy)
	enemy.died.connect(_on_boss_died)
