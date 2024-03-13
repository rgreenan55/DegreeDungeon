extends CanvasLayer
class_name UI

@onready var health_bar = $Control/MarginContainer/VBoxContainer/HBoxContainer/HealthBar
@onready var health_label = $Control/MarginContainer/VBoxContainer/HBoxContainer/HealthLabel
@onready var energy_bar = $Control/MarginContainer/VBoxContainer/HBoxContainer2/EnergyBar
@onready var energy_label = $Control/MarginContainer/VBoxContainer/HBoxContainer2/EnergyLabel

var health = 100:
	set(new_health):
		health = new_health
		_update_health_label()
		
var energy = 100:
	set(new_energy):
		energy = new_energy
		_update_health_label()
		
func _ready():
	_update_health_label()
		
func _update_health_label():
	health_label.text = str(health)
	
func _update_energy_label():
	energy_label.text = str(energy)

# TODO:
#	- Design the sprites for the health/energy bar
#	- Map values of health/energy to specific animation sprites for the bars
