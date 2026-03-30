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
var artisan_nodes = (null)
var clock_node: Node = null

#region Registration Functions
# Other nodes will call these functions to let us know they exist.

# Register the log
func register_logger(logger: Node) -> void:
	logger_node = logger

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

# Register the ledger to the game_controller
func register_ledger(ledger: Control):
	ledger_node = ledger

# Register the clock
func register_clock(clock: Node) -> void:
	clock_node = clock
	
#endregion Registration Functions

#region Logic Handlers
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
	## kc 10/25/2025 here is where the trade items are determined. 
	## A helper function could be implemented to update these items based on user input.
	## There is also NO ERROR HANDLING OR CHECKING FOR REALISTIC VALUES lol. 
	var npc_gives_item = "Sword"
	var player_gives_item = "Coins"
	
	# Command the UI to open the trade
	trade_ui_node.open_trade(player_node, npc_who_was_clicked, player_gives_item, npc_gives_item)

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
		
#endregion Logic Handlers

#region Debug
# Takes a TestName param and a CharIn param for the name of the test and the
# Character you want to print details for.
func debug(TestName, CharIn):
	print("####################\n\tdebug\n####################")
	print(
		str("Testing: "+TestName),
		"\nname: ", CharIn.char_name,
		"\nlocation: ",CharIn.location,
		"\ngender: ",CharIn.gender,
		"\nrace: ",CharIn.race,
		# TODO: print foreach inventory item and it's quant
		"\ninventory:\n\t\t[Sword: ",CharIn.inventory.Sword,
		"] [Strudel: ",CharIn.inventory.Strudel,"] [Coins: ",CharIn.inventory.Coins,
		"] ",
		"\nprofession: ",CharIn.profession
		# TODO: get and print current dialgue quest/location 
	)
	#print(
		#"#######\nTrade prep\n#######"
	#)
	#if CharIn == Player:
		#Player.trade(Baker, "Coins", 5, "Strudel", 1)
	#print(
			#"Seems they did the trade!\nPlayer Inv: ",Player.inventory,
			#"\nBaker Inv:",Baker.inventory
	#)
	pass
#endregion Debug
