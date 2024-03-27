extends Node2D

signal picked_up
signal finished

var used = false
@export var timeRemaining = 10.0

var player = CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if used:
		timeRemaining -= delta
		if timeRemaining <= 0:
			endBoost()
	pass


func _on_body_entered(body):
	if body.is_in_group("Player") and not used and not body.is_invincible:
		player = body
		startBoost()
		picked_up.emit()
		visible = false

func startBoost():
	player.is_invincible = true
	used = true
	pass
	
func endBoost():
	player.is_invincible = false
	finished.emit()
	queue_free()
	pass
