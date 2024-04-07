extends CharacterBody2D

var player : CharacterBody2D
var speed : int


func _ready():
	player = get_tree().current_scene.get_node("Player")
	$AnimatedSprite2D.play("dancing")
	speed = 50

func _process(delta):
	var direction = (player.position - position).normalized()

	if (position.distance_to(player.position) > 20):
		position += direction * speed * delta

func _physics_process(_delta):
	move_and_slide()


