extends Resource
#class_name Character 

# Character attributes (e.g., gender, role, race)
@export var gender: Array[String] = ["Male", "Female", "Other"]
@export var profession: Array[String] = ["Baker", "Miller", "Mason", "Smith", "Jewler", "Carpenter", "Tanner", "Brewer", "Stable-Master"]
@export var race: Array[String] = ["Human", "Dwarf", "Gnome", "Elf", "Orc", "Dragonborn"] #you know who asked for Dragonborn to be added here ʕ·͡ᴥ·ʔ
@export var inventory: String

# Exported variables for the character's stats
@export var influence: int = 0
@export var fluency: int = 0
@export var diplomacy: int = 0
@export var negotiation: int = 0
#@export var disposition: int = 0

# Optional: Add a method to reset the character's stats
func reset():
	influence = 0
	fluency = 5
	diplomacy = 0
	negotiation = 0
	#disposition = 5

# TODO: Fix methods to calculate derived values
func get_char_attr(attr) -> int:
	attr = 0
	return attr

# TODO: a function to roll the character objects stats on creation.
# func roll_stats() -> array:
#     var stats = roll_dice(4,10)
#     pass  
