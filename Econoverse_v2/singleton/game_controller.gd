# --- game_controller.gd ---
# This script acts as a Centralized Event Bus and prevents objects, scripts, nodes etc. from having
# to connect to eachother. everything connects to the game_controller
extends Node

## kc 10/25/25; functions for mechanics and interactive systems
## can register to the game_controller. This way, values are passed from the
## singleton and we don't have to manually assign actors to
## each other within their functions.
## ex: GameController.register_player(self) on
## the player script's ready function will assign the 
## player and values. 

# We will store references to key nodes as they "check in"
var logger_node: Node = null
var player_node: Node = null
var trade_ui_node: Control = null
var ledger_node: Control = null
var artisan_nodes: Array = []
var clock_node: Node = null

signal inventory_changed

func _ready() -> void:
	# Wait until the end of the first frame so all scene nodes have run their _ready()
	# and registered themselves before we run startup checks.
	await get_tree().process_frame
	_check_node_registration()
	_verify_world_supply()

# Log errors for any required node that failed to register before the first frame.
func _check_node_registration() -> void:
	if not player_node:
		Logging.log_error("GameController: player_node not registered at game start.")
	if not trade_ui_node:
		Logging.log_error("GameController: trade_ui_node not registered at game start.")
	if not ledger_node:
		Logging.log_error("GameController: ledger_node not registered at game start.")
	if not clock_node:
		Logging.log_error("GameController: clock_node not registered at game start.")
	if not artisan_nodes:
		Logging.log_error("GameController: no artisan_nodes registered at game start.")

# Confirm the world supply based on the ledger method
func _verify_world_supply() -> void:
	if ledger_node and ledger_node.has_method("verify_supply"):
		ledger_node.verify_supply()
	elif not ledger_node:
		Logging.log_warn("GameController: ledger_node not registered — supply verification skipped.")

#region Registration Functions
# Other nodes will call these functions to let us know they exist.

# Register the log
func register_logger(logger: Node) -> void:
	logger_node = logger

func register_player(player: Node):
	player_node = player
	Logging.log_info("Player registered: %s" % player.char_name)

func register_trade_ui(ui: Control):
	trade_ui_node = ui
	trade_ui_node.hide() # Ensure it's hidden at the start
	Logging.log_info("Trade UI registered.")

func register_artisan(artisan: Node):
	# When an artisan registers, we immediately connect its signal
	# to our central handler function then append the node to the artisan_nodes array.
	if not artisan.artisan_clicked.is_connected(_on_artisan_clicked):
		artisan.artisan_clicked.connect(_on_artisan_clicked)
	artisan_nodes.append(artisan)

# Register the ledger to the game_controller
func register_ledger(ledger: Control):
	ledger_node = ledger
	Logging.log_info("Ledger registered.")

# Register the clock
func register_clock(clock: Node) -> void:
	clock_node = clock

#endregion Registration Functions

#region Logic Handlers
# This function is moved from Playground.gd. It now runs globally.

func _on_artisan_clicked(clicked_npc: Node):

	# A good safety check to make sure our nodes have registered
	if not player_node:
		Logging.log_error("GameController: Player is not registered — cannot open trade.")
		return
	if not trade_ui_node:
		Logging.log_error("GameController: Trade UI is not registered — cannot open trade.")
		return

	# --- Define the trade from NPC data ---
	var npc_gives_item = clicked_npc.offered_item if "offered_item" in clicked_npc else "Sword"
	var player_gives_item = clicked_npc.wanted_item if "wanted_item" in clicked_npc else "Coins"

	Logging.log_info("Trade opened: Player ↔ %s | Player gives: %s | NPC gives: %s" \
		% [clicked_npc.char_name, player_gives_item, npc_gives_item])

	# Command the UI to open the trade
	trade_ui_node.open_trade(player_node, clicked_npc, player_gives_item, npc_gives_item)

# Register trade to game controller
func on_trade_complete(trade: Dictionary) -> void:
	#DEBUG Print Statements
	# Confirms GameController received the trade dictionary from Class_Character.
	# If this doesn't print, the on_trade_complete() call in Class_Character.gd didn't reach here.
	print("[GAME_CONTROLLER] on_trade_complete received: ", trade)
	# Shows what ledger_node is pointing to. If null, register_ledger() was never called
	# or ui_ledger hasn't loaded yet.
	print("[GAME_CONTROLLER] ledger_node is: ", ledger_node)
	
	# Builds a formatted log string by slotting the trade dictionary values into a template.
	# %s = string, %d = integer. So for a trade where the player gives 10 Coins for 1 Sword from Bogus Buchannon, it produces:
	# TRADE: Player gave 10 Coins for 1 Sword from Bogus Buchannon
	var msg = "TRADE: %s gave %d %s for %d %s from %s" % [
		trade.trader, trade.val_give, trade.item_give,
		trade.val_get, trade.item_get, trade.tradee
	]
	# Above string is then passed to Logging.log_info(msg) on the next line, which writes it to the log file and emits it to the log window. 
	Logging.log_info(msg)
	if ledger_node:
		ledger_node.track(trade)
	
	# Every trade emit a signal to GameController to show a trade happened and inventory is updated.
	inventory_changed.emit()
	
#endregion Logic Handlers
