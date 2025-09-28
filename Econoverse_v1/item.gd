@tool
extends Resource
class_name Item
# TODO: durf 09/02/25 - Can we rename this "commodities" and leave the option for "items" open
#		for other things?

@export var id : int
@export var start_price : int
@export var name_full : String = "" #what you want to display in quest context etc
@export var name_abbreviated : String = "" #useful for cramped interfaces, extensive lists
@export_multiline var description : String = ""
@export var texture: Texture2D
@export var world_supply: int = 0

# Not necessary to use. Could be a simple way to establish rules for quests etc. 
# Doesn't need to be a player-forward value, let the world/characters emphasize the value.

# durf 09/02/25 - I like this a lot, but will it be determined by the
# world_supply or world_supply + distribution between merchants (supply/demand)?
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

func get_id() -> int:
	return id

func set_start_price(new_start_price: int):
	start_price = new_start_price

func get_start_price() -> int:
	return start_price

func set_name_full(new_name_full: String):
	name_full = new_name_full

func get_name_full() -> String:
	return name_full

func set_name_abbreviated(new_name_abbreviated: String):
	name_abbreviated = new_name_abbreviated

func get_name_abbreviated() -> String:
	return name_abbreviated

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
