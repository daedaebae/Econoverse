@tool
class_name CharacterResource
extends Resource

# NOTE: Character attributes and data in the resource, funcs in the node!
@export var char_name: String
@export var location: Location
@export var gender: Gender
@export var inventory: Dictionary = {
	"Coins": 0, 
	"Slots": {
		1: "", 2: "", 3: ""
	}
}
@export var race: String = "Human"
@export var profession: Profession

enum Profession{
	None,
	Carpenter,
	Smith,
	Stablemaster,
	Baker,
	Brewer,
	Mason,
	Tanner
}

enum Gender {
	Male,
	Female,
	Other
}

#region LocationStateMachine
enum Location { 
	Lumber_Mill,
	Smithy,
	Stables,
	Bakery,
	Brewhouse,
	Masonic_Shop,
	Tannery,
	Town_Square
}

#TODO: Connect to relevant scene/shop/conversation.
func _process(delta: float) -> void:
	match location:
		Location.Lumber_Mill:
			pass
		Location.Smithy:
			pass
		Location.Stables:
			pass
		Location.Bakery:
			pass
		Location.Brewhouse:
			pass
		Location.Masonic_Shop:
			pass
		Location.Tannery:
			pass
		Location.Town_Square:
			pass
			
#endregion LocationStateMachine

# Constructor not needed?
#func _init(name, location, currency, gender, race, profession) -> void:
	#pass

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
