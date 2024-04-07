extends CanvasLayer

@export var entity: Node2D

@onready var name_label = %NameLabel
@onready var health_bar = %HealthBar

func _ready():
	name_label.visible = false
	health_bar.visible = false

func initialize(entity_instance: Node2D):
	if entity_instance:
		entity = entity_instance
		entity.s_damaged.connect(update_health)
		name_label.text = entity.name
		update_health()
		name_label.visible = true
		health_bar.visible = true

func update_health():
	if entity:
		health_bar.value = entity.current_health * 100 / entity.max_health
