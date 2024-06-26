extends Node

var current_year: int : set = _set_current_year, get = _get_current_year
var current_scene: String : set = _set_current_scene, get = _get_current_scene
var scenes_cleared: int : set = _set_scenes_cleared, get = _get_scenes_cleared

# The years array represents the macro-scopic breakdown
# of the levels within the game. Each year has a subset of
# scenes which represent the levels required to beat that year
var years = [0, 1, 2, 3, 4]

# The year_scenes 2D array represent all of the
# scenes that form a particular year based on index.
# For example: the array of scenes at index 1 represent
# all scenes that make up year 1!
var year_scene_idx = 0
var year_scenes = [
	[	# Year 0
		"res://scenes/main/Main.tscn",
		"res://scenes/world_0/player_home.tscn",
	],
	[	# Year 1
		"res://scenes/world_1/DormStart.tscn",	#1
		"res://scenes/world_1/Hall.tscn",		#2
		"res://scenes/world_1/Class2.tscn",		#5
		"res://scenes/world_1/Hall.tscn",		#4
		"res://scenes/world_1/Class3.tscn",		#9
		"res://scenes/world_1/Hall.tscn",		#6
		"res://scenes/world_1/Library2.5.tscn",	#7
		"res://scenes/world_1/Hall.tscn",		#8
		"res://scenes/world_1/Class1.tscn",		#3
		"res://scenes/world_1/Hall.tscn",		#10
		"res://scenes/world_1/Class4.tscn",		#11
		"res://scenes/world_1/Hall.tscn",		#12
		"res://scenes/world_1/FinalBoss5.tscn"
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

# The year_scenes 2D array represent all of the
# starting positions of the player for each scene
# within each year. Each entry in this 2D array
# corresponds to the starting position for the
# entry in the year_scenes array
var year_player_positions = [
	[	# Year 0
		Vector2(0, 0),
		Vector2(536, 565),
	],
	[	# Year 1
		Vector2(232.5, 91.24),	#1
		Vector2(49, 145),		#2
		Vector2(88, 32),		#5
		Vector2(96, 100),		#4
		Vector2(56, 192),		#9
		Vector2(144, 100),		#6
		Vector2(64, 30),		#7
		Vector2(352, 100),		#8
		Vector2(32, 46),		#3
		Vector2(560, 100),		#10
		Vector2(56, 193),		#11
		Vector2(736, 100),		#12
		Vector2(32, 64),		#13
	],
	[	# Year 2
		Vector2(0, 0),
	],
	[	# Year 3
		Vector2(0, 0),
	],
	[	# Year 4
		Vector2(0, 0),
	],
]

# The menus dictionary contains all available menus in the game
# and their scenes. This dictionary is accessed through the
# get_menu_path(menu_name) method that returns the menu scene
# for the given menu name if it exists
var menus = {
	"title_menu": "res://menus/title/title_menu.tscn",
	"acceptance_letter": "res://menus/acceptance_letter/acceptance_letter.tscn",
	"game_over": "res://menus/game_over/game_over.tscn"
}

func reset() -> void:
	# Reset all variables to their defaults
	current_year = 0
	current_scene = year_scenes[current_year][0]
	scenes_cleared = 0
	year_scene_idx = 0

# Return the path of the next scene for the current year if
# there is one, otherwise switch to the next year and the first
# scene in that year.
#
# State variables are set through execution.
func next_scene_path() -> String:
	if year_scene_idx < year_scenes[current_year].size() - 1:
		year_scene_idx += 1
		_set_current_scene(year_scenes[current_year][year_scene_idx])
		return current_scene

	# If the above fails, then we must move onto the next year.
	_set_current_year(current_year + 1)
	year_scene_idx = 0
	_set_current_scene(year_scenes[current_year][0])
	return current_scene

# Return the Vector2D starting position of the player
# for the current scene. If, for whatever reason,
# we cannot find the starting vector, then return (0, 0).
#
# State variables are no set through execution.
func player_starting_position() -> Vector2:
	if year_scene_idx < year_player_positions[current_year].size():
		return year_player_positions[current_year][year_scene_idx]
	else:
		return Vector2(0, 0)

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
	year_scene_idx = 0
	_set_current_scene(year_scenes[current_year][year_scene_idx])
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

# Adds one to the number of scenes that have been cleared
#
# State variables are set through execution.
func scene_cleared() -> void:
	_set_scenes_cleared(scenes_cleared + 1)

func _get_scenes_cleared() -> int:
	return scenes_cleared

func _set_scenes_cleared(new_scenes_cleared: int) -> void:
	scenes_cleared = new_scenes_cleared
