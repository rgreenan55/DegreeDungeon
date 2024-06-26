extends Node2D

@onready var speech_bubble = %SpeechBubble
@onready var room_transition = %RoomTransition

@export_multiline var story_for_next_level

var speech_bubble_text_idx: int = 0
var speech_bubble_text = [
	"I could use some caffeine...",
	"Ahhh, now I'm ready!"
]

signal s_next_level
signal s_enable_player
signal s_enable_ui
signal s_disable_follow_camera
signal s_play_audio(audio_name)
signal s_show_story_letter(str, title)

func _ready():
	s_enable_player.emit()
	s_enable_ui.emit()
	s_disable_follow_camera.emit()
	_display_speech()

func _on_room_transition_s_transition_room():
	s_next_level.emit()
	s_show_story_letter.emit(story_for_next_level, "FIRST CLASS")

func _on_health_pickup_picked_up():
	s_play_audio.emit("Drinking")
	room_transition.s_transition_room.connect(_on_room_transition_s_transition_room)
	speech_bubble_text_idx += 1
	_display_speech()

func _display_speech():
	speech_bubble.set_text(speech_bubble_text[speech_bubble_text_idx])
