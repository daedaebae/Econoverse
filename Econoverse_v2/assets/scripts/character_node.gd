@tool
class_name Character 
extends CharacterBody2D
#kc 10/24/25; added for early ui integration testing etc
@export var Playground: Control
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

#mouse funcs
@onready var mouse_position: Vector2

#Character attribs
@export var char_name: String = "Name"
#@export var currency: int
@export var location: Location = 7
@export var gender: Gender = 2
@export var race: String = "Human"
@export var profession: Profession = 0
@export var inventory: Dictionary = {"Sword": 0, "Strudel": 0, "Coins": 10}
@export var met : bool = false

# Constructor
#func _init(char_name, loc, gen, r, prof, inv):
	#self.char_name = char_name
	#self.location = loc
	#self.gender = gen
	#self.race = r
	#self.profession = prof
	#self.inventory = inv
	#pass

#durf 09/15/25 - v1.0 simple trade func sets dicts, v2.0 trade func with adjust
#				 Item objects within inventory dicts.
func trade(whom: Character, valGive: int, item_give: String, valGet: int, item_get: String):
	#whasappenin'
	print("Player traded ",whom.char_name," ",valGive," ",item_give," for ",valGet," ",item_get)
	# Player give val1# of item_give to the whom
	self.inventory[item_give] = (self.inventory[item_give] - valGive)
	whom.inventory[item_give] = (whom.inventory[item_give] + valGive)
	# Player get val2# of item_get from whom
	self.inventory[item_get] = (self.inventory[item_get] + valGet)
	whom.inventory[item_get] = (whom.inventory[item_get] - valGet)
	
	print_inv_values()

#FIXME: durf 10/21/25 Draft - Click trade button activate trade function

#TEST: kc 10/25/25 commented out this version and 
# for testing new version before merge.
#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.is_pressed() \
	#and event.button_index == MOUSE_BUTTON_LEFT:
		##Get mouse postion and set the target
		#mouse_position = get_viewport().get_mouse_position()
		#var target = $CollisionShape2D
		#var distance = mouse_position.distance_to(target.global_position)
		## If clicked near the player collision shape run the trade function
		#if distance < 20:
			##TODO: 10/21/25 if click trade button then 1 for 1 trade item for item
			## this doesn't work right now as it will trade item with itself.
			#trade( $"../Artisan", 10, "Coins", 1, "Sword")
			#print("Player: ",self.inventory,"\nArtisan: ",$"../Artisan".inventory)
			#pass
			
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() \
	and event.button_index == MOUSE_BUTTON_LEFT:
		#Get mouse postion and set the target
		mouse_position = get_viewport().get_mouse_position()
		var target = $CollisionShape2D
		var distance = mouse_position.distance_to(target.global_position)
		# If clicked near the player collision shape run the trade function
		if distance < 20:
			Playground.start_trade_with_npc(self)
			
			
			pass

#kc 10/24/25; moved this to a callable method so it can be called elsewhere. 
# it now passes the whom variable and will only print if there is a whom.
func print_inv_values():
	print (self.name," now has: ",self.inventory)
	
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
