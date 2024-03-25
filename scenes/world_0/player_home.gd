extends Node2D

@onready var player = $Player
@onready var player_camera = $PlayerCamera
@onready var mom_speech_bubble = %MomSpeechBubble

# Variables
var mom_text_pre_trigger = [
	"Adammm",
	"Adam quick come here!",
	"Adam where are you?"
]

var has_adam_triggered_mom: bool = false

func _ready():
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
		# Pull from the array of speech bubbles
		mom_speech_bubble.set_text(mom_text_pre_trigger.pick_random())
	else:
		pass

func _on_mom_timer_timeout():
	if !has_adam_triggered_mom:
		_update_mom_speech()


func _on_mom_trigger_body_entered(body):
	print(body.name)
