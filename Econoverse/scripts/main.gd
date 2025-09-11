extends Node

# TODO: Use main.gd to preload/load/run assets, resources, scripts, and other
#		items as needed or at compile time.
# TODO: Continue migrating everything to main


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Godot loads the Resource when it reads this very line.	
	var imported_resource = preload("res://resources/Items.json")
	preload("res://scripts/worldclock.gd")
	Player.test_shit()
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

#region Characters
@export var Player = Character.new(
	"Iona",
	7,
	10,
	"Female",
	"Human",
	"Choose a profession"
)

@export var Smith = Character.new(
	"Bron",
	1,
	700,
	"Male",
	"Human",
	"Smith"
)
@export var Baker = Character.new(
	"Tiebyrn",
	3,
	400,
	"Male",
	"Human",
	"Baker"
)
@export var Stablemaster = Character.new(
	"Brygna",
	2,
	1000,
	"Female",
	"Human",
	"Stablemaster"
)
@export var Tanner = Character.new(
	"Leomund",
	6,
	600,
	"Male",
	"Human",
	"Tanner"
)
@export var Brewer = Character.new(
	"Tymeria",
	4,
	800,
	"Female",
	"Human",
	"Brewer"
)
@export var Mason = Character.new(
	"Glorifen",
	5,
	800,
	"Other",
	"Human",
	"Mason"
)
@export var Carpenter = Character.new(
	"Flick",
	0,
	600,
	"Male",
	"Human",
	"Carpenter"
)
#endregion Characters
