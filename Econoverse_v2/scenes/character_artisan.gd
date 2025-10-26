# --- Artisan.gd ---
# This is the "Artisan" specific script.
# It also inherits EVERYTHING from Character.gd.
@tool
extends Character
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
# This signal is for the Artisan only.
signal artisan_clicked(npc: Node)

func _ready():
	# "Hello GameController, I am an artisan. Listen to me."
	# ONLY artisans register as an artisan.
	GameController.register_artisan(self)
	
	if not input_event.is_connected(_on_input_event):
		input_event.connect(_on_input_event)

# This is the click-handler.
# It will now be called when the CharacterBody2D's *own* shape is clicked.
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	
	if event is InputEventMouseButton and event.is_pressed() \
	and event.button_index == MOUSE_BUTTON_LEFT:
		
		# Emit the signal from the Artisan (self)
		artisan_clicked.emit(self)
		print( self.char_name + " was clicked, emits signal." )
