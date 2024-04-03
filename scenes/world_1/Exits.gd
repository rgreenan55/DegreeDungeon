extends Node2D

func _ready():
	visible = false
	_disable_door_collisions()

func _on_enemy_died():
	visible = true
	_enable_door_collisions()

func _enable_door_collisions():
	for door in get_children():
		if door.has_method("_enable_collision"):
			door._enable_collision()
			
func _disable_door_collisions():
	for door in get_children():
		if door.has_method("_disable_collision"):
			door._disable_collision()
