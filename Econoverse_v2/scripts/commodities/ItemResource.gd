@tool
class_name ItemResource
extends Resource

@export var id : int
@export var start_price : int
@export var name_full : String = "" #what you want to display in quest context etc
@export var name_abbreviated : String = "" #useful for cramped interfaces, extensive lists
@export_multiline var description : String = ""
@export var texture: Texture2D
@export var world_supply: int = 0
@export var rarity : Rarity = Rarity.COMMON

enum Rarity { 
	COMMON,
	RARE,
	UNCOMMON
}

# Decide later if we want to classify items or not, feels broad scope to work in the logic
### enum ItemType { farm , clothes , ??? }

# Get tooltip text currently set for item
func get_tooltip() -> String:
	var tooltip_text = name_full + "\n"
	tooltip_text += description + "\n\n"
	tooltip_text += "Value: " + str(start_price) + "\n"
	# tooltip_text += "Rarity: " + str(rarity)
	return tooltip_text

func get_item_data() -> Dictionary:
	return {
		"id": id,
		"start_price": start_price,
		"name_full": name_full,
		"name_abbreviated": name_abbreviated,
		"description": description,
		"texture": texture,
		"world_supply": world_supply,
		"rarity": rarity
	}
