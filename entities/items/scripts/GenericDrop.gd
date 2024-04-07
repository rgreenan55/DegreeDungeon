extends Node2D

@onready var pickup = %Pickup
@onready var animation_player = %AnimationPlayer

# List of all possible drops that can be instantiated
var powerups = [
	"res://entities/items/objects/FullHealthPickup.tscn",
	"res://entities/items/objects/HealthPickup.tscn",
	"res://entities/items/objects/InvincibilityPickup.tscn",
	"res://entities/items/objects/MaxHealthPickup.tscn",
	"res://entities/items/objects/SpeedPickup.tscn"
]

signal s_picked_up

var powerup_instance

func _ready():
	var powerup = load(powerups.pick_random())
	if powerup:
		powerup_instance = powerup.instantiate()
		powerup_instance.get_node("CollisionShape2D").disabled = true
		powerup_instance.picked_up.connect(_picked_up)
		pickup.add_child(powerup_instance)
		animation_player.play("Drop_Fade_In")

func _picked_up():
	s_picked_up.emit()
	# We should queue free here but we can't cause invincibility

func enable_pickup():
	powerup_instance.get_node("CollisionShape2D").disabled = false
