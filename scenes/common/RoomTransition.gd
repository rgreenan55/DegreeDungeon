extends Node2D

@export var scene_transition = Control
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		scene_transition.transition_to(GameState.next_scene_path())

func _disable_collision():
	$Area2D/CollisionShape2D.disabled = true
	
func _enable_collision():
	$Area2D/CollisionShape2D.disabled = false
