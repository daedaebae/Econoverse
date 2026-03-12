@tool
extends Resource
class_name LedgerResource

#TODO: 	durf - Update the dictionary to include all items and data points needing to be
# 		displayed within the ledger. Ledger could be displayed to player later,
#		but will be initially used as tooling for tracking item progressions.

@export var id = 0
@export var start_price = 0
@export var current_price = 0
@export var name_full = ""
@export var name_abbreviated = ""
@export var description = ""
#TODO: set image variable
#@export var texture = ("res://assets/...")
@export var world_supply = 1000
@export var rarity = Item.Rarity.COMMON

@export var ledger = {
		"id": id,
		"start_price": start_price,
		"current_price": current_price,
		"name_full": name_full,
		"name_abbreviated": name_abbreviated,
		"description": description,
		#"texture": texture,
		"world_supply": world_supply,
		"rarity": rarity
	}
