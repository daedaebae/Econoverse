@tool
class_name CharacterResource
extends Resource

@export var char_name: String
@export var location: Location
@export var gender: Gender
@export var race: Race
@export var profession: Profession
#durf: maybe rename later
@export var	state: State
## kc 10/25/25; could implement a function that updates the inventory dynmically 
## based on new items? such as, if item not in dictionary, assign value 
## after final value etc etc. Maybe need enums to ensure no duplicates or naming errors.
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

# Sets the player state to show what they are doing.
enum State{
	TRAVELING,
	INTERACTING,
	MENU
}

enum Profession{
	UNEMPLOYED,
	CARPENTER,
	SMITH,
	STABLEMASTER,
	BAKER,
	BREWER,
	MASON,
	TANNER
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

#region LocationStateMachine
enum Location{ 
	LUMBER_MILL,
	SMITHY,
	STABLES,
	BAKERY,
	BREWHOUSE,
	MASONIC_SHOP,
	TANNERY,
	TOWN_SQUARE
}

#TODO: Connect to relevant scene/shop/conversation.
#func _process(delta: float) -> void:
	#match location:
		#Location.LUMBER_MILL:
			#pass
		#Location.SMITHY:
			#pass
		#Location.STABLES:
			#pass
		#Location.BAKERY:
			#pass
		#Location.BREWHOUSE:
			#pass
		#Location.MASONIC_SHOP:
			#pass
		#Location.TANNERY:
			#pass
		#Location.TOWN_SQUARE:
			#pass
			
#endregion LocationStateMachine

#region NodeFunctions
func trade_item(item_in: Item,item_out: Item):
	
	print("item_in: "+item_in.name+"\nitem_out: "+item_out.name)
	

#TODO: durf 09/14/25 - Implement in v3.0
# Optional: Add a method to reset the character's stats
#func reset_stats():
	#_stats.set("influence", 0)
	#_stats.set("fluency", 0)
	#_stats.set("diplomacy", 0)
	#_stats.set("negotiation", 0)
	#_stats.set("disposition", 0)

# TODO: a function to roll the character objects stats on creation.
# func roll_stats() -> array:
#     var stats = roll_dice(4,10)
#     pass

#endregion NodeFunctions
