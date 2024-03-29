extends Node

var current_year: int : set = _set_current_year, get = _get_current_year
var current_scene: String : set = _set_current_scene, get = _get_current_scene

# The years array represents the macro-scopic breakdown
# of the levels within the game. Each year has a subset of
# scenes which represent the levels required to beat that year
var years = [0, 1, 2, 3, 4]

# The year_scenes 2D array represent all of the 
# scenes that form a particular year based on index.
# For example: the array of scenes at index 1 represent
# all scenes that make up year 1!
var year_scenes = [
	[	# Year 0
		"res://scenes/main/Main.tscn",
		"res://scenes/world_0/player_home.tscn",
	],
	[	# Year 1
		"res://scenes/main/Test.tscn",
	],
	[	# Year 2
		"",
	],
	[	# Year 3
		"",
	],
	[	# Year 4
		"",
	],
]

# The menus dictionary contains all available menus in the game
# and their scenes. This dictionary is accessed through the
# get_menu_path(menu_name) method that returns the menu scene
# for the given menu name if it exists
var menus = {
	"title_menu": "res://menus/title/title_menu.tscn",
	"acceptance_letter": "res://menus/acceptance_letter/acceptance_letter.tscn"
}

func reset() -> void:
	# Reset all variables to their defaults
	current_year = 0
	current_scene = year_scenes[current_year][0]
	
# Return the path of the next scene for the current year if
# there is one, otherwise switch to the next year and the first
# scene in that year. 
#
# State variables are set through execution.
func next_scene_path() -> String:
	var current_scene_idx = year_scenes[current_year].find(current_scene, 0)
	if current_scene_idx != -1 and current_scene_idx < year_scenes[current_year].size() - 1:
		_set_current_scene(year_scenes[current_year][(current_scene_idx + 1)])
		return current_scene
	
	# If the above fails, then we must move onto the next year.
	_set_current_year(current_year + 1)
	_set_current_scene(year_scenes[current_year][0])
	return current_scene
	
# Return the path of the menu scene in the menus
# dictionary that corresponds to the provided
# menu_name key. 
#
# State variables are not set through execution.
func get_menu_path(menu_name: String) -> String:
	assert(menu_name in menus)
	return menus[menu_name]
	
# Returns the first scene for the current year
# and sets that as the current scene.
#
# State variables are set through execution.
func start_of_year() -> String:
	_set_current_scene(year_scenes[current_year][0])
	return current_scene

func _get_current_year() -> int:
	return current_year

func _set_current_year(year: int) -> void:
	# Check to make sure we are trying to switch to a valid year
	assert(year in years)
	current_year = year

func _get_current_scene() -> String:
	return current_scene

func _set_current_scene(scene: String) -> void:
	# Check to make sure the scene we are trying to switch
	# to is part of the current year
	assert(scene in year_scenes[current_year])
	current_scene = scene

