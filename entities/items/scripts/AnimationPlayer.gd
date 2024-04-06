extends AnimationPlayer

@export var animationName = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	play(animationName)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_animation_finished(_anim_name):
	play(animationName)
