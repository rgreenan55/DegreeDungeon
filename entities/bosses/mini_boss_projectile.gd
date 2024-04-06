extends Area2D
@export var player : PackedScene

var direction = Vector2.ZERO
var speed = 150
var player_node : Node2D
#grab player position to send projectile towards it
func _ready():
	player_node = get_tree().current_scene.get_node("Player")
	var miniboss_node = self.get_parent() #get the parent node enemy is in
	direction = (player_node.position - miniboss_node.position).normalized()
	reparent(miniboss_node.get_parent()) #reparent to main scene where enemy is in
	
func _process(delta):
	position += direction * speed * delta
	$AnimatedSprite2D.play("projectile")
