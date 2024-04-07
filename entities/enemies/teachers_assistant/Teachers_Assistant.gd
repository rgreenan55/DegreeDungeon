extends CharacterBody2D

# References
@onready var animation : AnimatedSprite2D = $AnimatedSprite
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D

# Signals
signal died

# Enums & Constants
enum EnemyStates { IDLE, ALERT, STUNNED }
const charge_speed = 200
const normal_speed = 30

# Variables
var move_speed : float
var health : int
var knockback : Vector2
var state : EnemyStates

var on_cooldown : bool

var player_in_range : bool
var player_in_sight : bool
var player : Node2D

# On Enemy Load
func _ready():
	state = EnemyStates.IDLE
	move_speed = normal_speed
	health = 5

	on_cooldown = false

	player_in_range = false
	player_in_sight = false
	player = get_tree().current_scene.get_node("Player")

# Processes
func _process(_delta):

	print("CD ", on_cooldown, " ", $ChargeCooldown.time_left)

	if (health == 0): die()
	play_animations()

# Processes Physics
func _physics_process(_delta):
	SightCheck()
	handle_movement()
	move_and_slide()

# Move Towards Next Navigation Point
func idle_movement():
	make_path()
	velocity = to_local(nav_agent.get_next_path_position()).normalized() * move_speed
func make_path():
	nav_agent.target_position = player.global_position
	$PathFindingTimer.start()

# Charge Towards Player
func alert_movement():
	if (on_cooldown):
		if (is_on_wall() or is_on_ceiling() or is_on_floor()):
			state = EnemyStates.STUNNED
			$StunnedTimer.start()
	else: # charge
		$PathFindingTimer.stop()
		velocity = position.direction_to(player.position) * charge_speed
		on_cooldown = true

# Movement
func handle_movement():
	if (state == EnemyStates.IDLE): idle_movement()
	if (state == EnemyStates.ALERT): alert_movement()
	if (state == EnemyStates.STUNNED): velocity = Vector2.ZERO

# Handles Animations
func play_animations():
	if (velocity.x == 0):
		if (velocity.y < 0): animation.play("move_up")
		elif (velocity.y > 0): animation.play("move_down")
		else: animation.play("idle")
	else:
		animation.play("move_left_right");
		if (velocity.x < 0): animation.flip_h = true
		else: animation.flip_h = false

func set_player_in_range(body : Node2D):
	print(body.get_groups())
	if (body.is_in_group("Player")):
		player_in_range = true

func set_player_out_of_range(body : Node2D):
	if (body.is_in_group("Player")):
		player_in_range = false
		player_in_sight = false

func SightCheck():
	if (player_in_range):
		var space_state = get_world_2d().direct_space_state
		var sight_check = space_state.intersect_ray(PhysicsRayQueryParameters2D.create(position, player.position, $Sight.collision_mask, []))

		if (sight_check && sight_check.collider.name == "Player" && !on_cooldown):
			state = EnemyStates.ALERT

func stun_over():
	state = EnemyStates.IDLE
	$ChargeCooldown.start()

func end_cooldown():
	on_cooldown = false

func hit_player(body : Node2D):
	if (body.is_in_group("Player")):
		velocity = Vector2.ZERO
		$ChargeCooldown.start()
		state = EnemyStates.IDLE

func handle_hit():
	if (state == EnemyStates.STUNNED):
		health -= 1

func die():
	print("boss died")
	died.emit()
	# Death Animation
	queue_free()
