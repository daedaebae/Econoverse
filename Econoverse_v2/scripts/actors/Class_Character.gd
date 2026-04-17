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
@export_range(1, 100) var disposition : int = 50
@export var location: Location = Location.TOWN_SQUARE
@export var accepts_only : Array[String] = []
	# Whitelist of item IDs this character will accept in trade. Empty = accepts
	# anything. Example: Taxman = ["Coin"] — rejects every other item with the
	# decline line. Data-driven so any future constrained NPC just fills this in.
@export var on_first_talk_event : EventResource
	# Optional. Fired by GameController.on_character_met the first time the player
	# meets this NPC. Leave null for NPCs with no first-meeting reaction.
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

# Returns the greeting this character should say when the player interacts.
# Currently returns speech_greeting directly. Future considerations:
# - First meeting: a unique introduction line (met == false)
# - Disposition-based: warmer or colder greetings based on disposition value
# - Event-driven: one-shot lines after specific events (e.g., tithe paid)
# - Quest-contextual: references to active or completed quests involving this NPC
# Subclasses (artisan.gd, player.gd) can override for character-specific logic.
func get_greeting() -> String:
	return speech_greeting

# Returns pending quest dialogue lines for this NPC, in the order the player
# should walk them. Each entry: { "quest_id": String, "line": String }.
# Does NOT mark lines as delivered — the popup calls QuestManager.mark_delivered
# after each line is safely shown. Empty array means the popup falls back to
# the default greeting (speech_greeting).
func on_talk() -> Array[Dictionary]:
	return QuestManager.get_pending_lines_for(id)

#TODO: durf- simplify params to use dictionary pulled from character inventory?
#kc - consider trade simply emitting data based on each possible comparison operation outcome.
func trade(whom: Character, valGive: int, item_give: String, valGet: int, item_get: String):
	# Receiver may restrict what it accepts. Empty list = accepts anything.
	if not whom.accepts_only.is_empty() and item_give not in whom.accepts_only:
		Logging.log_warn("Trade rejected: %s — %s" \
			% [whom.char_name, whom.speech_trade_decline])
		return false
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
			"trader_id": self.id,
			"tradee": whom.char_name,
			"tradee_id": whom.id,
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
