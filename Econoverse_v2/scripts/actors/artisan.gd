# --- Artisan.gd ---
# This is the "Artisan" specific script.
# It also inherits EVERYTHING from the Character Class (Class_Character.gd)
extends Character
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
# This signal is for the Artisan only.
signal artisan_clicked(npc: Node)

func _ready():
	# "Hello GameController, I am an artisan. Listen to me."
	# ONLY artisans register as an artisan.
	GameController.register_artisan(self)

# This is the click-handler.
# It will now be called when the Artisan's *own* shape is clicked.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() \
		and event.button_index == MOUSE_BUTTON_LEFT:
		if GameController.trade_ui_node and GameController.trade_ui_node.visible:
			return
		var mouse_pos = get_global_mouse_position()
		if global_position.distance_to(mouse_pos) < 20:
			artisan_clicked.emit(self)
			get_viewport().set_input_as_handled()
