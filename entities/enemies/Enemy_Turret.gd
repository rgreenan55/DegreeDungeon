extends Area2D
@export var projectile_template : PackedScene
# References
@onready var animation : AnimatedSprite2D = $AnimatedSprite2D

# Variables
var health : int

# On Enemy Load
func _ready():
	health = 3

#This enemy is static like a turret
func _process(delta):
	animation.play("move")

#4 projectiles shooting in the up, down left and right directions
func _on_shoot_timer_timeout():
	var projectile_up = projectile_template.instantiate()
	var projectile_down = projectile_template.instantiate()
	var projectile_left = projectile_template.instantiate()
	var projectile_right = projectile_template.instantiate()
	add_child(projectile_up)
	add_child(projectile_down)
	add_child(projectile_left)
	add_child(projectile_right)
	projectile_up.reparent(self.get_parent())
	projectile_down.reparent(self.get_parent())
	projectile_left.reparent(self.get_parent())
	projectile_right.reparent(self.get_parent())
	projectile_up.direction.y = -1
	projectile_down.direction.y = 1
	projectile_left.direction.x = -1
	projectile_right.direction.x = 1
