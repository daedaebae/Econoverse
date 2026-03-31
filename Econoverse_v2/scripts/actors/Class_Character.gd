class_name Character
extends CharacterBody2D

#kc 10/24/25; added for early ui integration testing etc
@export var Playground: Control
#mouse funcs
#TODO: kc 02/21/26; we'll have proximity based interaction, but still enable clicking on entities to
# view simple details. Could also design a way for entities to not provide full details until they are
# met/discovered. Curiosity opportunity
@onready var mouse_position: Vector2
@export var char_name: String = "Name"
@export var location: Location = Location.TOWN_SQUARE
@export var gender: Gender
@export var race: Race
@export var profession: Profession = Profession.UNEMPLOYED
# Alphabetized Inventory Dict
@export var inventory: Dictionary = {
	"Boots": 0,
	"Coins": 0, 
	"Corn": 0,
	"Horses": 0,
	"Lumber": 0,
	"Stone": 0,
	"Strudel": 0, 
	"Sword": 0, 
	"Whiskey": 0,
}
@export var met : bool = false

# Maps each profession to the item they produce and sell.
# Used by artisan.gd to auto-set offered_item from profession.
const PROFESSION_ITEM: Dictionary = {
	Profession.BAKER:       "Strudel",
	Profession.BREWER:      "Whiskey",
	Profession.CARPENTER:   "Lumber",
	Profession.MASON:       "Stone",
	Profession.SMITH:       "Sword",
	Profession.STABLEMASTER: "Horses",
	Profession.TANNER:      "Boots",
	Profession.UNEMPLOYED:  "Corn",
}

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
func trade(whom: Character, valGive: int, item_give: String, valGet: int, item_get: String):
	# Check if the values are higher than what is in Character Inventories.
	if valGive > self.inventory[item_give]:
		Logging.log_warn("Trade rejected: %s does not have enough %s (has %d, needs %d)." \
			% [char_name, item_give, self.inventory[item_give], valGive])
	elif valGet > whom.inventory[item_get]:
		Logging.log_warn("Trade rejected: %s does not have enough %s (has %d, needs %d)." \
			% [whom.char_name, item_get, whom.inventory[item_get], valGet])
	else:
		Logging.log_info("Trade executed: %s gave %d %s to %s for %d %s." \
			% [char_name, valGive, item_give, whom.char_name, valGet, item_get])
		# Player give val1# of item_give to the whom
		self.inventory[item_give] = (self.inventory[item_give] - valGive)
		whom.inventory[item_give] = (whom.inventory[item_give] + valGive)
		# Player get val2# of item_get from whom
		self.inventory[item_get] = (self.inventory[item_get] + valGet)
		whom.inventory[item_get] = (whom.inventory[item_get] - valGet)

		#Print player inventory.
		print_inv_values()

		#DEBUG Print Statements
		# Confirms a valid trade passed all checks and inventory has been updated.
		# Shows who traded what, quantities, and both parties involved.
		print("[TRADE] Initiating: ", self.char_name, " → ", whom.char_name, " | giving ", valGive, " ", item_give, " for ", valGet, " ", item_get)
		# Confirms the GameController is about to be notified. If you see [TRADE] but not
		# [GAME_CONTROLLER], the on_trade_complete() call or the GC reference is broken.
		print("[TRADE] Inventory updated. Notifying GameController.")

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
#endregion CharFunctions

#TEST: kc 10/25/25 commented out this version and 
# for testing new version before merge.
#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.is_pressed() \
	#and event.button_index == MOUSE_BUTTON_LEFT:
		##Get mouse postion and set the target
		#mouse_position = get_viewport().get_mouse_position()
		#var target = $CollisionShape2D
		#var distance = mouse_position.distance_to(target.global_position)
		## If clicked near the player collision shape run the trade function
		#if distance < 20:
			##TODO: 10/21/25 if click trade button then 1 for 1 trade item for item
			## this doesn't work right now as it will trade item with itself.
			#trade( $"../Artisan", 10, "Coins", 1, "Sword")
			#print("Player: ",self.inventory,"\nArtisan: ",$"../Artisan".inventory)
			#pass
			
## kc 10/25/25; testing for game_controller
#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.is_pressed() \
	#and event.button_index == MOUSE_BUTTON_LEFT:
		##Get mouse postion and set the target
		#mouse_position = get_viewport().get_mouse_position()
		#
		#var target = $CollisionShape2D
#
		#
		#var distance = mouse_position.distance_to(target.global_position)
		## If clicked near the player collision shape run the trade function
		#
		## kc 10/25/25; checks if target is player. If so, does nothing.
		## can be updated later to perform a different interaction.
		#if target == Player:
			#return
		#
		#if distance < 20:
			#Playground.start_trade_with_npc(self)
			#
			#
			#pass

func _ready() -> void:
	pass

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
	LUMBER_MILL,
	MASONIC_SHOP,
	SMITHY,
	STABLES,
	TANNERY,
	TOWN_SQUARE
}
