# --- player.gd ---
# This is the "Player" specific script.
# It inherits EVERYTHING from the Character Class (Class_Character.gd)

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
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	if direction != Vector2.ZERO:
		#player moves along diagonal isometric axis
		var iso_direction = Vector2(direction.x, direction.y * 0.5)
		
		velocity = iso_direction.normalized() * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
