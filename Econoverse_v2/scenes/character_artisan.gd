# --- Artisan.gd ---
# This is the "Artisan" specific script.
# It also inherits EVERYTHING from Character.gd.
@tool
extends Character

# This signal is for the Artisan only.
signal artisan_clicked(npc: Node)

func _ready():
	# "Hello GameController, I am an artisan. Listen to me."
	# ONLY artisans register as an artisan.
	GameController.register_artisan(self)
	
	# Connect the signal from our CHILD Area2D
	# Make sure your Area2D node is named "ClickableArea"
	var area = $ClickableArea
	if area:
		area.input_event.connect(_on_input_event)
	else:
		print("Artisan" + self.name + " is missing a 'ClickableArea' child node!")

# This is the click-handler. It only exists on the Artisan.
# We MOVED this logic out of Character.gd.
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() \
	and event.button_index == MOUSE_BUTTON_LEFT:
		
		# Emit the signal *from the Artisan (self)*, not the area
		artisan_clicked.emit(self)
