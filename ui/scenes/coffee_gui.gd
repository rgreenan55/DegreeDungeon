extends Panel

@onready var sprite = $Sprite2D 

# Update the sprite to either show a coffee cup or a transparent sprite
func update(whole: bool):
	if whole:
		# A full coffee cup
		sprite.frame = 164
	else:
		# A transparent sprite
		sprite.frame = 163	
