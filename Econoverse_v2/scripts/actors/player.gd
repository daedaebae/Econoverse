# --- player.gd ---
# This is the "Player" specific script.
# It inherits EVERYTHING from the Character Class (Class_Character.gd)
@tool
extends Character
# We can add player-specific logic here, like movement.
@export var speed: float = 300.0



# _ready() is a "virtual" function. This code will run
# IN ADDITION to any _ready() code in Character.gd.
func _ready():
	# Register player_node with game_controller
	GameController.register_player(self)
	
	# Print player inventory value
	#print_inv_values()
	

# Player-specific input handling
func _physics_process(_delta: float):
	# Example: Player-only movement logic
	# (Assumes you have "ui_left", "ui_right", etc. set in Input Map)
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()
	
