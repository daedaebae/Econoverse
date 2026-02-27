@tool
class_name Character
extends CharacterBody2D

#kc 10/24/25; added for early ui integration testing etc
@export var Playground: Control
#mouse funcs
#TODO: kc 02/21/26; we'll have proximity based interaction, but still enable clicking on entities to
# view simple details. Could also design a way for entities to not provide full details until they are
# met/discovered. Curiosity opportunity
@onready var mouse_position: Vector2
#TODO: durf- char_name is not ideal! X-D
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

#region CharFunctions

func print_inv_values():
	print (self.char_name," Inventory: ",self.inventory)

#TODO: durf- simplify params to use dictionary pulled from player inventory?
func trade(whom: Character, valGive: int, item_give: String, valGet: int, item_get: String):
	# Check if the values are higher than what is in Character Inventories.
	if valGive > self.inventory[item_give]:
		print("Can't make that trade, not enough ", item_give, ".")
	elif valGet > whom.inventory[item_get]:
		print("Can't make that trade, not enough ", item_get, ".")
	else:
		# Print what is happening.
		print("Player traded ",whom.char_name," ",valGive," ",item_give," for ",valGet," ",item_get)
		# Player give val1# of item_give to the whom
		self.inventory[item_give] = (self.inventory[item_give] - valGive)
		whom.inventory[item_give] = (whom.inventory[item_give] + valGive)
		# Player get val2# of item_get from whom
		self.inventory[item_get] = (self.inventory[item_get] + valGet)
		whom.inventory[item_get] = (whom.inventory[item_get] - valGet)
		#Print player inventory.
		print_inv_values()
		
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

# Sets the player state to show what they are doing.
enum State{
	INTERACTING,
	MENU,
	TRAVELING
}

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
