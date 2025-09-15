# FIXME: dmurf 09/14/25 -  couldn't get resource classes to work as expected, moved on to using
#						   simpler classes. Will reattempt in v2
#@tool
#class_name CharacterResource
#extends Resource
#
## DONE: Character attributes and data in the resource, funcs in the node!
#@export var char_name: String
#@export var currency: int
#@export var location: Location
#@export var gender: Gender
##@export var gender: Array[String] = ["Male", "Female", "Other"]
#@export var inventory: Dictionary = {"Coins": 0}
#@export var race: String = "Human"
	##"Dwarf",
	##"Gnome",
	##"Elf",
	##"Orc",
	##"Dragonborn"
##] #you know who asked for Dragonborn to be added here ʕ·͡ᴥ·ʔ
#@export var profession: Profession
##@export var profession:Array[String] = [
	###"Carpenter",
	##"Smith",
	###"Stablemaster",
	##"Baker"#,
	###"Brewer",
	###"Mason",
	###"Tanner"
##]
##@export var _stats: Dictionary = {
	##"influence": 0,
	##"fluency": 0,
	##"diplomacy": 0,
	##"negotiation": 0,
	##"disposition": 0
##}
#enum Profession{
	#None,
	#Carpenter,
	#Smith,
	#Stablemaster,
	#Baker,
	#Brewer,
	#Mason,
	#Tanner
#}
#
#enum Gender {
	#Male,
	#Female,
	#Other
#}
#
##region LocationStateMachine
#enum Location { 
	#Lumber_Mill,
	#Smithy,
	#Stables,
	#Bakery,
	#Brewhouse,
	#Masonic_Shop,
	#Tannery,
	#Town_Square
#}
#
##TODO: Connect to relevant scene/shop/conversation.
#func _process(delta: float) -> void:
	#match location:
		#Location.Lumber_Mill:
			## Run carpenter convo scene
			##
			#pass
		#Location.Smithy:
			#pass
		#Location.Stables:
			#pass
		#Location.Bakery:
			#pass
		#Location.Brewhouse:
			#pass
		#Location.Masonic_Shop:
			#pass
		#Location.Tannery:
			#pass
		#Location.Town_Square:
			#pass
			#
##endregion LocationStateMachine
#
## Constructor not needed?
##func _init(name, location, currency, gender, race, profession) -> void:
	##pass
#
##region NodeFunctions
#func trade(item_in: Item,item_out: Item):
	#print("item_in: "+item_in.name+"\nitem_out: "+item_out.name)
#
##TODO: durf 09/14/25 - Implement in v3.0
## Optional: Add a method to reset the character's stats
##func reset_stats():
	##_stats.set("influence", 0)
	##_stats.set("fluency", 0)
	##_stats.set("diplomacy", 0)
	##_stats.set("negotiation", 0)
	##_stats.set("disposition", 0)
#
## TODO: a function to roll the character objects stats on creation.
## func roll_stats() -> array:
##     var stats = roll_dice(4,10)
##     pass
#
##endregion NodeFunctions
