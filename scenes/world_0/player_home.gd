extends Node2D

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
var first_call = true

signal s_enable_player
signal s_enable_follow_camera
signal s_show_menu(menu_name)

func _ready():
	s_enable_player.emit()
	s_enable_follow_camera.emit()
	_update_mom_speech()

func _process(_delta):
	$HomeMusic.position = get_tree().current_scene.get_node("Player").position

func _update_mom_speech():
	if !has_adam_triggered_mom:
		# Pull a random text prompt from the pre trigger array as busy talk
		mom_speech_bubble.set_text(mom_text_pre_trigger.pick_random())
		if first_call:
			first_call = false
			return
		$PreTriggerSound.playing = true
	elif mom_text_idx < mom_text_post_trigger.size():
		# Pull a text prompt from the post trigger array in order
		mom_speech_bubble.set_text(mom_text_post_trigger[mom_text_idx])
		mom_text_idx += 1
		$PreTriggerSound.playing = false
		$PostTriggerSound.playing = true

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
		s_show_menu.emit("acceptance_letter")
