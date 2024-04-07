extends CanvasLayer

@onready var animation_player = %AnimationPlayer
@onready var grade_icon = %grade_icon

var grades = [
	"res://menus/common/a_gui.tscn",
	"res://menus/common/b_gui.tscn",
	"res://menus/common/c_gui.tscn",
	"res://menus/common/d_gui.tscn",
]

func assign_grade(grade: String):
	var new_grade = load("res://menus/common/{grade}_gui.tscn".format({"grade": grade}))
	if new_grade:
		var grade_instance = new_grade.instantiate()
		grade_icon.add_child(grade_instance)

func display_report_card():
	# THIS PLAYER FREEZING STUFF IS GROSS IM SORRY IT'S DUE TODAY
	var player = null
	if get_tree().get_nodes_in_group("Player").size() > 0:
		player = get_tree().get_nodes_in_group("Player")[0]
		player.process_mode = Node.PROCESS_MODE_DISABLED

	animation_player.play("Report_Card_Appear")
	await animation_player.animation_finished
	animation_player.play_backwards("Report_Card_Appear")
	await animation_player.animation_finished

	if player:
		player.process_mode = Node.PROCESS_MODE_INHERIT
