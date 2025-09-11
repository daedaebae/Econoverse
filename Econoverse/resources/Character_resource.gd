extends Resource
class_name Character 

# TODO: Character attributes and data in the resource, funcs in the node!
@export var name: String = ""
#@export var character_name: String = ""
@export var currency: int = 0
@export var gender: Array[String] = ["Male", "Female", "Other"]
@export var inventory: Array = []
@export var race: Array[String] = [
	"Human",
	"Dwarf",
	"Gnome",
	"Elf",
	"Orc",
	"Dragonborn"
] #you know who asked for Dragonborn to be added here ʕ·͡ᴥ·ʔ
@export var profession:Array[String] = [
	"Carpenter",
	"Smith",
	"Stablemaster",
	"Baker",
	"Brewer",
	"Mason",
	"Tanner"
]
@export var _stats: Dictionary = {
	"influence": 0,
	"fluency": 0,
	"diplomacy": 0,
	"negotiation": 0,
	"disposition": 0
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

var location: Location
#TODO: Connect to relevant scene/shop/conversation.
func _process(delta: float) -> void:
	match location:
		Location.Lumber_Mill:
			# Run carpenter convo scene
			#
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
			
#@export var location: Array[String] = [
	#"Lumber Mill",
	#"Smithy",
	#"Stables",
	#"Bakery",
	#"Brewhouse",
	#"Masonic Shop",
	#"Tannery",
	#"Town Square"
#]
#endregion LocationStateMachine

# Constructor
func _init(name, location, currency, gender, race, profession) -> void:
	# name = name
	# location = location
	# currency = currency
	# gender = gender
	# race = race
	# profession = profession
	pass

#region NodeFunctions
func trade(item_in: Item,item_out: Item):
	print("item_in: "+item_in.name+"\nitem_out: "+item_out.name)

# Optional: Add a method to reset the character's stats
func reset_stats():
	_stats.set("influence", 0)
	_stats.set("fluency", 0)
	_stats.set("diplomacy", 0)
	_stats.set("negotiation", 0)
	_stats.set("disposition", 0)

# DONE?: Fix methods to calculate derived values
# Unnecessary: getters and setters for nodes come default
#func get_stat(attr) -> int:
	#return stats.get(attr)
#func set_stat(attr, num):
	#stats.set(attr, num)


# TODO: a function to roll the character objects stats on creation.
# func roll_stats() -> array:
#     var stats = roll_dice(4,10)
#     pass  
func test_shit():
	print("testing_shit")
	print(location)

#endregion NodeFunctions
