extends Node2D

signal picked_up
signal finished

var used = false
@export var timeRemaining = 10.0

@export var speedMulti = 1.5
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
	if body.is_in_group("Player") and not used and not body.is_speedy:
		player = body
		startBoost()
		picked_up.emit()
		visible = false

func startBoost():
	player.move_speed *= speedMulti
	player.is_speedy = true
	used = true
	pass
	
func endBoost():
	# BUG: IF THE PLAYER LEAVES THE ROOM
	# BEFORE THIS ENDS THEN IT NEVER ENDS!
	player.move_speed /= speedMulti
	player.is_speedy = false
	finished.emit()
	queue_free()
	pass
