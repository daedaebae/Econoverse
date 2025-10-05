#TODO: 	Review Getters and Setters for any missing functions that manipulate
#		items.

@tool
extends Resource
class_name Item

@export var id : int
@export var start_price : int
@export var name_full : String = "" #what you want to display in quest context etc
@export var name_abbreviated : String = "" #useful for cramped interfaces, extensive lists
@export_multiline var description : String = ""
@export var texture: Texture2D
@export var world_supply: int = 0

enum Rarity { COMMON , UNCOMMON , RARE }
@export var rarity : Rarity = Rarity.COMMON

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

#TODO:	New trade functions for v2
func tradeItem():
	# Trade item logic here
	# GD.print("Traded item: %s for %f" % [itemName, itemCost])
	pass

# Get the items ID, no setter needed as ID is established in code when defined
func get_id() -> int:
	return id

# Get the start price of the item
func get_start_price() -> int:
	return start_price

# Set the start price of the item
func set_start_price(new_start_price: int):
	start_price = new_start_price

# Get the full name of the item
func get_name_full() -> String:
	return name_full

# Set the full name of the item
func set_name_full(new_name_full: String):
	name_full = new_name_full

# Get the abbreviated name of the item
func get_name_abbreviated() -> String:
	return name_abbreviated

func set_name_abbreviated(new_name_abbreviated: String):
	name_abbreviated = new_name_abbreviated


func set_description(new_description: String):
	description = new_description

func get_description() -> String:
	return description

func set_texture(new_texture: Texture2D):
	texture = new_texture

func get_texture() -> Texture2D:
	return texture

func set_world_supply(new_world_supply: int):
	world_supply = new_world_supply

func get_world_supply() -> int:
	return world_supply

func set_rarity(new_rarity: Rarity):
	rarity = new_rarity

func get_rarity() -> Rarity:
	return rarity
