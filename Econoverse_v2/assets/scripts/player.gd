@tool
class_name Player 
extends CharacterBody2D
#extends CharacterResource

# DONE: Char behaviors and animations in the Node, data in the resource! load all the stuff from 
#		the resource(will try again in v2)
@export var CharRes = preload("res://assets/scripts/character_resource.gd")
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
@export var met : bool = false

# Constructor
func _init(char_name, loc, gen, r, prof, inv) -> void:
	self.char_name = char_name
	self.location = loc
	self.gender = gen
	self.race = r
	self.profession = prof
	self.inventory = inv

#durf 09/15/25 - v1.0 simple trade func sets dicts, v2.0 trade func with adjust
#				 Item objects within inventory dicts.
func trade(whom: Player, valIn: int, item_give: String, valOut: int, item_get: String):
	#whasappenin'
	print("Player traded ",valIn," ",item_give," for ",valOut," ",item_get)
	# Player give val1# of item_give to the whom
	self.inventory[item_give] = (self.inventory[item_give] - valIn)
	whom.inventory[item_give] = (whom.inventory[item_give] + valIn)
	# Player get val2# of item_get from whom
	self.inventory[item_get] = (self.inventory[item_get] + valOut)
	whom.inventory[item_get] = (whom.inventory[item_get] - valOut)

#FIXME: durf 10/22/25 Draft - Click trade button activate trade function
func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo():
		return
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			#TODO: 10/21/25 if click trade button then 1 for 1 trade item for item
			# this doesn't work right now as it will trade item with itself.
			trade( self, 1, "item_give", 1, "item_get")
			print("did it work?")
			pass


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
