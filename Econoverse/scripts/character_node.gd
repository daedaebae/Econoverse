@tool
class_name Character
extends Node2D

# DONE: Char behaviors and animations in the Node, data in the resource! load all the stuff from 
#		the resource(will try again in v2)
#@export var CharRes: CharacterResource = preload("res://resources/character_resource.tres")
#@export var CharRes: CharacterResource = load("CharacterResource")

#@export var char_name: String = CharRes.char_name
#@export var location: int = CharRes.location
#@export var currency: int = CharRes.currency
#@export var gender: int = CharRes.gender
#@export var race: String = CharRes.race
#@export var profession: int = CharRes.profession

@export var char_name: String
#@export var currency: int
@export var location: Location
@export var gender: Gender
@export var race: String = "Human"
@export var profession: Profession
@export var inventory: Dictionary = {"Sword": 0, "Strudel": 0, "Coins": 0}


# Constructor
func _init(name, loc, gen, r, prof, inv):
	self.char_name = name
	self.location = loc
	self.gender = gen
	self.race = r
	self.profession = prof
	self.inventory = inv
	pass

#durf 09/15/25 - v1.0 simple trade func sets dicts, v2.0 trade func with adjust
#				 Item objects within inventory dicts.
func trade(whom: Character, item_give: String, val1: int, item_get: String, val2: int):
	#whasappenin'
	print("Player traded ",val1," ",item_give," for ",val2," ",item_get)
	# Player give val1# of item_give to the whom
	self.inventory[item_give] = (self.inventory[item_give] - val1)
	whom.inventory[item_give] = (whom.inventory[item_give] + val1)
	# Player get val2# of item_get from whom
	self.inventory[item_get] = (self.inventory[item_get] + val2)
	whom.inventory[item_get] = (whom.inventory[item_get] - val2)

func _ready() -> void:
	pass

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
