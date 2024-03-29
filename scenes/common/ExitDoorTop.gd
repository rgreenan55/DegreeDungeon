extends Node2D

@export var scene_transition = Control
# Called when the node enters the scene tree for the first time.
func _ready():
	$RoomTransition.scene_transition = scene_transition
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _disable_collision():
	$RoomTransition._disable_collision()
	
func _enable_collision():
	$RoomTransition._enable_collision()
