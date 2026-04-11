class_name Character
extends CharacterBody2D

#region exports
#@durf can you add validation log to ensure unique IDs and check for duplicates?
@export var id : String = "npc_default" #name for programmatic reference, stable
@export var char_name: String = "Name" #name seen and used by the game, flexible and changeable
@export var sprite: Sprite2D = null
@export var gender: Gender
@export var race: Race
@export var profession: Profession = Profession.UNEMPLOYED
# Alphabetized Inventory Dict
@export var inventory: Dictionary = {
	"Boots": 0,
	"Coin": 0, 
	"Corn": 0,
	"Horse": 0,
	"Timber": 0,
	"Stone": 0,
	"Strudel": 0, 
	"Sword": 0, 
	"Whiskey": 0,
}
@export_group("Social")
@export var met : bool = false
@export var location: Location = Location.TOWN_SQUARE
@export_subgroup("Speech")
@export var speech_greeting : String = "Hello"
@export var speech_goodbye : String = "Goodbye"
@export var speech_trade_accept : String = "Thank you"
@export var speech_trade_decline : String = "I don't want that"

#TODO: kc 02/21/26; we'll have proximity based interaction, but still enable 
# clicking on entities to view simple details. 
# Could also design a way for entities to not provide full details until 
# they are met/discovered. Curiosity opportunity! 
@onready var mouse_position: Vector2
#endregion

#region CharFunctions

func print_inv_values():
	print (self.char_name," Inventory: ",self.inventory)

# Returns only items with a quantity greater than 0.
# Used by inventory UI to decide what to display.
func get_visible_inventory() -> Dictionary:
	var visible := {}
	for item in inventory:
		if inventory[item] > 0:
			visible[item] = inventory[item]
	return visible

#TODO: durf- simplify params to use dictionary pulled from character inventory?
#kc - consider trade simply emitting data based on each possible comparison operation outcome.
func trade(whom: Character, valGive: int, item_give: String, valGet: int, item_get: String):
	# Check if the values are higher than what is in Character Inventories.
	if valGive > self.inventory[item_give]:
		Logging.log_warn("Trade rejected: %s does not have enough %s (has %d, needs %d)." \
			% [char_name, item_give, self.inventory[item_give], valGive])
		return false
	elif valGet > whom.inventory[item_get]:
		Logging.log_warn("Trade rejected: %s does not have enough %s (has %d, needs %d)." \
			% [whom.char_name, item_get, whom.inventory[item_get], valGet])
		return false
	else:
		#trade is successful, update all values
		Logging.log_info("Trade executed: %s gave %d %s to %s for %d %s." \
			% [char_name, valGive, item_give, whom.char_name, valGet, item_get])
		#trading works through 
		# Player give val1# of item_give to the whom
		self.inventory[item_give] = (self.inventory[item_give] - valGive)
		whom.inventory[item_give] = (whom.inventory[item_give] + valGive)
		# Player get val2# of item_get from whom
		self.inventory[item_get] = (self.inventory[item_get] + valGet)
		whom.inventory[item_get] = (whom.inventory[item_get] - valGet)
		
		# GameController Pipeline
		# Notify the GameController that a trade has been completed.
		# This sends a dictionary containing details about the trade.
		GameController.on_trade_complete({
			"trader": self.char_name,
			"tradee": whom.char_name,
			"item_give": item_give,
			"val_give": valGive,
			"item_get": item_get,
			"val_get": valGet,
		})
		return true

		#@durf nothing at this line and below will run since there are returns above -kc
		print_inv_values()

		#DEBUG Print Statements
		# Confirms a valid trade passed all checks and inventory has been updated.
		# Shows who traded what, quantities, and both parties involved.
		print("[TRADE] Initiating: ", self.char_name, " → ", whom.char_name, " | giving ", valGive, " ", item_give, " for ", valGet, " ", item_get)
		# Confirms the GameController is about to be notified. If you see [TRADE] but not
		# [GAME_CONTROLLER], the on_trade_complete() call or the GC reference is broken.
		print("[TRADE] Inventory updated. Notifying GameController.")



#endregion CharFunctions

#region const/enums
# Maps each profession to the item they produce and sell.
# Used by artisan.gd to auto-set offered_item from profession.
#kc 04/11 should use item resource references for this, may need to move up to a singleton
const PROFESSION_ITEM: Dictionary = {
	Profession.BAKER:       "Strudel",
	Profession.BREWER:      "Whiskey",
	Profession.CARPENTER:   "Timber",
	Profession.MASON:       "Stone",
	Profession.SMITH:       "Sword",
	Profession.STABLEMASTER: "Horses",
	Profession.TANNER:      "Boots",
	Profession.UNEMPLOYED:  "Corn",
}

# Sets the character state to show what they are doing.
enum State{
	INTERACTING,
	MENU,
	TRAVELING
}

# Sets character profession (1 at a time)
enum Profession{
	BAKER,
	BREWER,
	CARPENTER,
	MASON,
	SMITH,
	STABLEMASTER,
	TANNER,
	UNEMPLOYED,
}

enum Gender{
	MALE,
	FEMALE,
	OTHER
}

enum Race{
	HUMAN,
	OTHER
}

enum Location{
	BAKERY,
	BREWHOUSE,
	Timber_MILL,
	MASONIC_SHOP,
	SMITHY,
	STABLES,
	TANNERY,
	TOWN_SQUARE
}
#endregion
