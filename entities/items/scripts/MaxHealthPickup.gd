extends Node2D

signal picked_up

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.max_health += 1
		body.current_health = body.max_health
		picked_up.emit()
		body.s_max_health_changed.emit(body.max_health)
		#body.s_health_changed.emit(body.current_health)
		queue_free()
