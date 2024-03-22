extends Node

var current_scene: String : set = _set_current_scene, get = _get_current_scene

# TODO: 
# We don't need to keep track of all scenes, but what we can do is
# keep track of all scenes for a particular level/year. So when we,
# for example, have to restart, we can simply look at the first
# scene in the array of scenes for our given year (which can also be stored here).
var _game_scenes = [
	"res://scenes/main/Test.tscn"
]

func _get_current_scene() -> String:
	return current_scene

func _set_current_scene(scene: String) -> void:
	assert(scene in _game_scenes)
	current_scene = scene
