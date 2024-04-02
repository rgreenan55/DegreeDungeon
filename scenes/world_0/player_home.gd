extends Node2D

@onready var ui = %UI
@onready var player = %Player
@onready var player_camera = $PlayerCamera
@onready var mom_speech_bubble = %MomSpeechBubble
@onready var mom_timer = %MomTimer
@onready var tile_map = $TileMap

# Variables
var mom_text_pre_trigger = [
	"Adammm",
	"Adam quick come here!",
	"Adam where are you?"
]

var mom_text_idx: int = 0
var mom_text_post_trigger = [
	"Oh hey honey",
	"I just saw the mailman out the window",
	"Can you check the mailbox?",
	"Thank you!"
]

var has_adam_triggered_mom: bool = false
var has_adam_triggered_mail: bool = false

func _ready():
	# Set max health in GUI to zero since we don't want that to be visible right now
	ui.set_max_health(0)
	ui.update_health(0)

	_update_mom_speech()
	_update_camera_pos()

func _process(delta):
	_update_camera_pos()

func _update_camera_pos():
	player_camera.position.x = player.position.x
	player_camera.position.y = player.position.y
	# player_camera.position = clamp(player_camera.position, Vector2(0, 0), Vector2(1152, 648))

func _update_mom_speech():
	if !has_adam_triggered_mom:
		# Pull a random text prompt from the pre trigger array as busy talk
		mom_speech_bubble.set_text(mom_text_pre_trigger.pick_random())
	elif mom_text_idx < mom_text_post_trigger.size():
		# Pull a text prompt from the post trigger array in order
		mom_speech_bubble.set_text(mom_text_post_trigger[mom_text_idx])
		mom_text_idx += 1

func _on_mom_timer_timeout():
	_update_mom_speech()

func _on_mom_trigger_body_entered(body):
	if body.name == "Player" and !has_adam_triggered_mom:
		# Set the triggered bool
		has_adam_triggered_mom = true
		# Remove door to leave house
		tile_map.set_layer_enabled(2, false)

func _on_mailbox_body_entered(body):
	if body.name == "Player" and !has_adam_triggered_mail:
		has_adam_triggered_mail = true
		ui.send_acceptance_letter()
