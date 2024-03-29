extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$ExitDoorTop._disable_collision()
	$ExitDoorTop2._disable_collision()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_just_pressed("dev_dmg"):
		#visible = true
		#$ExitDoorTop._enable_collision()
		#$ExitDoorTop2._enable_collision()
	pass


func _on_enemy_died():
	visible = true
	$ExitDoorTop._enable_collision()
	$ExitDoorTop2._enable_collision()
	pass # Replace with function body.
