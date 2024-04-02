extends CanvasLayer
class_name UI

@onready var CoffeeGui = preload("res://ui/player_ui/scenes/coffee_gui.tscn")
@onready var health_container = %HealthContainer

var health = 5:
	set(new_health):
		health = new_health

func set_max_health(max_hp : int):
	print("Health before set max: " + str(health_container.get_child_count()))
	for child in health_container.get_children():
		health_container.remove_child(child)
	for i in range(max_hp):
		var coffee = CoffeeGui.instantiate()
		health_container.add_child(coffee)

func update_health(current_health: int):
	if current_health < 0:
		return
	current_health = min(health_container.get_child_count(), current_health)

	var coffee_cups = health_container.get_children()

	for i in range(current_health):
		coffee_cups[i].update(true)

	for i in range(current_health, coffee_cups.size()):
		coffee_cups[i].update(false)
