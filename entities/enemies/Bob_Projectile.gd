extends Area2D
@export var player : PackedScene

var direction = Vector2.ZERO
var speed = 180
var player_node : Node2D
#grab player position to send projectile towards it
func _ready():
	player_node = get_tree().current_scene.get_node("Player")
	var enemy_node = self.get_parent() #get the parent node enemy is in
	direction = (player_node.position - enemy_node.position).normalized()
	reparent(enemy_node.get_parent()) #reparent to main scene where enemy is in
	
func _process(delta):
	position += direction * speed * delta
	$AnimatedSprite2D.play("projectile")

#decrements the current_health of player if projectile enters player body
func _on_body_entered(body):
	if (body.is_in_group("Player")):
		body.current_health -= 1
		var health = body.current_health
		body.s_health_changed.emit(health)
		
