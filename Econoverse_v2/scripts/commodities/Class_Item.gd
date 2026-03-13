@tool
extends Sprite2D
class_name Item

@export var attribs: Dictionary = {
	"ID": 0,
	"Start Price": 0,
	"Name Full": "",
	"Name Abbreviated": "",
	"Description": "",
	"World Supply": 0,
	"Rarity": Rarity
}

enum Rarity { 
	COMMON,
	RARE,
	UNCOMMON
}

# Decide later if we want to classify items or not, feels broad scope to work in the logic
### enum ItemType { farm , clothes , ??? }

# Get tooltip text currently set for item
#func get_tooltip() -> String:
	#var tooltip_text = name_full + "\n"
	#tooltip_text += description + "\n\n"
	#tooltip_text += "Value: " + str(start_price) + "\n"
	## tooltip_text += "Rarity: " + str(rarity)
	#return tooltip_text
#
#func get_item_data() -> Dictionary:
	#return {
		#"id": id,
		#"start_price": start_price,
		#"name_full": name_full,
		#"name_abbreviated": name_abbreviated,
		#"description": description,
		#"texture": texture,
		#"world_supply": world_supply,
		#"rarity": rarity
	#}
