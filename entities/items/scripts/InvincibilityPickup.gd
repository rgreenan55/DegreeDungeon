extends Node2D

signal picked_up
signal finished

var used = false
@export var timeRemaining = 10.0

var player = CharacterBody2D

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
	# BUG: IF THE PLAYER LEAVES THE ROOM BEFORE
	# THIS FIRES THEN THEY STAY INVINCIBLE 
	player.is_invincible = false
	finished.emit()
	queue_free()
	pass
