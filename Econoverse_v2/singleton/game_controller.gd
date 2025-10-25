# --- game_controller.gd ---
extends Node

## kc 10/25/25; functions for mechanics and interactive systems
## can register to the game_controller. This way, values are passed from the
## singleton and we don't have to manually assign actors to 
## each other within their functions. 
## ex: GameController.register_player(self) on
## the player script's ready function will assign the 
## player and values. 

# We will store references to key nodes as they "check in"
var player_node: Node = null
var trade_ui_node: Control = null


# --- Registration Functions ---
# Other nodes will call these functions to let us know they exist.

func register_player(player: Node):
	player_node = player

func register_trade_ui(ui: Control):
	trade_ui_node = ui
	trade_ui_node.hide() # Ensure it's hidden at the start

func register_artisan(artisan: Node):
	# When an artisan registers, we immediately connect its signal
	# to our central handler function.
	if not artisan.artisan_clicked.is_connected(_on_artisan_clicked):
		artisan.artisan_clicked.connect(_on_artisan_clicked)


# --- Logic Handlers ---
# This function is moved from Playground.gd. It now runs globally.

func _on_artisan_clicked(npc_who_was_clicked: Node):
	
	# A good safety check to make sure our nodes have registered
	if not player_node:
		print("GameController Error: Player is not registered.")
		return
	if not trade_ui_node:
		print("GameController Error: Trade UI is not registered.")
		return
	
	# --- Define the trade (or get it from the NPC) ---
	var npc_gives_item = "gold"
	var player_gives_item = "wood"
	
	# Command the UI to open the trade
	trade_ui_node.open_trade(player_node, npc_who_was_clicked, player_gives_item, npc_gives_item)
