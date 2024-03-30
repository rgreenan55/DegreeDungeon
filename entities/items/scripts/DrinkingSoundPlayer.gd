extends Node2D

func _play_sound():
	$Drinking.playing = true

func _on_drinking_finished():
	$Moan.playing = true
