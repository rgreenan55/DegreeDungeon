extends Node2D

@onready var dialog_label = %DialogLabel

func _ready():
	visible = false

func set_text(text: String, wait_time: int = 3): 
	visible = true
	dialog_label.text = text
