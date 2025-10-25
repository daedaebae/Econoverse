extends Control

# Preload the UI scene
@export var TradeUI: Control

# This is your existing function. It will be CALLED BY the UI.
func trade(whom: Character, valGive: int, item_give: String, valGet: int, item_get: String):
	#whasappenin'
	print("Player traded ",whom.char_name," ",valGive," ",item_give," for ",valGet," ",item_get)
	# ... your inventory logic ...
	self.inventory[item_give] = (self.inventory[item_give] - valGive)
	whom.inventory[item_give] = (whom.inventory[item_give] + valGive)
	self.inventory[item_get] = (self.inventory[item_get] + valGet)
	whom.inventory[item_get] = (whom.inventory[item_get] - valGet)

# This func is called by the player
func start_trade_with_npc(npc_node):
	var npc_gives_item = "gold"
	var player_gives_item = "wood"
	
	# Call the global Autoload instance directly
	TradeUI.open_trade(self, npc_node, player_gives_item, npc_gives_item)
