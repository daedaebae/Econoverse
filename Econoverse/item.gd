@tool
extends Resource
class_name Item

@export var id : int
@export var start_price : int
@export var name_full : String = "full name" #what you want to display in quest context etc
@export var name_abbreviated : String = "abrv" #useful for cramped interfaces, extensive lists
@export_multiline var description : String = ""
@export var texture: Texture2D

# Not necessary to use. Could be a simple way to establish rules for quests etc. 
# Doesn't need to be a player-forward value, let the world/characters emphasize the value.
enum Rarity { COMMON , UNCOMMON , RARE }
@export var rarity : Rarity = Rarity.COMMON

# Decide later if we want to classify items or not, feels broad scope to work in the logic
### enum ItemType { farm , clothes , ??? }

func get_tooltip() -> String:
	var tooltip_text = name_full + "\n"
	tooltip_text += description + "\n\n"
	tooltip_text += "Value: " + str(start_price) + "\n"
	# tooltip_text += "Rarity: " + str(rarity)
	return tooltip_text
