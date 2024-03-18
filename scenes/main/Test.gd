extends Node2D

@onready var Player = $Player
@onready var UIContainer = $UI

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set max health in GUI to that of the player
	UIContainer.set_max_health(Player.max_health)
	UIContainer.update_health(Player.current_health)
	# Connect the health changed signal of the player to the UI
	Player.s_health_changed.connect(UIContainer.update_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
