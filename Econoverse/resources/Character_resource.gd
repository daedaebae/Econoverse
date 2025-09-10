extends Resource
class_name Character 

# TODO: Character attributes and data in the resource, funcs in the node!

@export var location = Location 
@export var character_name: String = ""
@export var currency: int = 0
@export var gender: Array[String] = ["Male", "Female", "Other"]
@export var stats: Dictionary = {
	"influence": 0,
	"fluency": 0,
	"diplomacy": 0,
	"negotiation": 0,
	"disposition": 0
}
@export var race: Array[String] = [
	"Human",
	"Dwarf",
	"Gnome",
	"Elf",
	"Orc",
	"Dragonborn"
] #you know who asked for Dragonborn to be added here ʕ·͡ᴥ·ʔ
@export var inventory: Array = []
@export var profession:Array[String] = [
	"Carpenter",
	"Smith",
	"Stablemaster",
	"Baker",
	"Brewer",
	"Mason",
	"Tanner"
]
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
# Optional: Add a method to reset the character's stats
func reset_stats():
	stats.set("influence", 0)
	stats.set("fluency", 0)
	stats.set("diplomacy", 0)
	stats.set("negotiation", 0)
	stats.set("disposition", 0)

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
