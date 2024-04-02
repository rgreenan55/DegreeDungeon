extends Node2D


func _ready():
	$ExitDoorTop._disable_collision()
	$ExitDoorTop2._disable_collision()
	pass # Replace with function body.

func _on_enemy_died():
	visible = true
	$ExitDoorTop._enable_collision()
	$ExitDoorTop2._enable_collision()
	pass # Replace with function body.
