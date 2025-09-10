extends Node

# TODO: Use main.gd to preload/load/run assets, resources, scripts, and other
#		items as needed or at compile time.
# TODO: Continue migrating everything to main


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Godot loads the Resource when it reads this very line.	
	var imported_resource = preload("res://resources/Items.json")
	preload("res://scripts/worldclock.gd")
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# DONE: Location State Machine
# Fun to learn, but may not need it. Check character node and resources for 
# location mgmt.
##region Location State-Machine
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
#@export var location : Location = Location.Town_Square
##endregion
