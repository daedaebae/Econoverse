extends Node

# TODO: Use main.gd to preload/load/run assets, resources, scripts, and other
#		items as needed or at compile time.
# TODO: Continue migrating everything to main

#region Create Character scene and objects

var CharScene = load("res://characters.tscn")
var CharSceneInstance = CharScene.instantiate()
var Char = CharSceneInstance

#durf 09/15/25 - Hardcoding inventory and items for v1.0
var Player = Character.new("Iona",7,1,"Human",0,{"Sword": 0, "Strudel": 0, "Coins": 5}, false)
var Smith = Character.new("Bron",1,0,"Human",0,{"Sword": 1, "Strudel": 0, "Coins": 700}, false)
var Baker = Character.new("Tiebyrn",3,"Female","Human",4,{"Sword": 0, "Strudel": 1, "Coins": 0}, false)
var Guard = Character.new("Roric Harthorne",7,0,"Human",0,{"Sword": 0, "Strudel":0, "Coins": 200}, false)

#@export var Stablemaster = Character.new(
	#"Brygna",
	#2,
	#1000,
	#"Female",
	#"Human",
	#"Stablemaster"
#)
#@export var Tanner = Character.new(
	#"Leomund",
	#6,
	#600,
	#"Male",
	#"Human",
	#"Tanner"
#)
#@export var Brewer = Character.new(
	#"Tymeria",
	#4,
	#800,
	#"Female",
	#"Human",
	#"Brewer"
#)
#@export var Mason = Character.new(
	#"Glorifen",
	#5,
	#800,
	#"Other",
	#"Human",
	#"Mason"
#)
#@export var Carpenter = Character.new(
	#"Flick",
	#0,
	#600,
	#"Male",
	#"Human",
	#"Carpenter"
#)

#endregion Create Character scene and objects

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Godot loads the Resource when it reads this very line.	
	var Items = preload("res://assets/Items.json")
	#preload("res://scripts/worldclock.gd")
	#debug("Player",Player)
	#debug("Smith",Smith)
	#debug("Baker",Baker)
	print("end")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# FIXME: DEBUG
# Takes a TestName param and a CharIn param for the name of the test and the
# Character you want to print details for.
func debug(TestName, CharIn):
	print("####################\n\tdebug\n####################")
	print(
		str("Testing: "+TestName),
		"\nname: ", CharIn.char_name,
		"\nlocation: ",CharIn.location,
		"\ngender: ",CharIn.gender,
		"\nrace: ",CharIn.race,
		# TODO: print foreach inventory item and it's quant
		"\ninventory:\n\t\t[Sword: ",CharIn.inventory.Sword,
		"] [Strudel: ",CharIn.inventory.Strudel,"] [Coins: ",CharIn.inventory.Coins,
		"] ",
		"\nprofession: ",CharIn.profession
		# TODO: get and print current dialgue quest/location 
	)
	#print(
		#"#######\nTrade prep\n#######"
	#)
	#if CharIn == Player:
		#Player.trade(Baker, "Coins", 5, "Strudel", 1)
	#print(
			#"Seems they did the trade!\nPlayer Inv: ",Player.inventory,
			#"\nBaker Inv:",Baker.inventory
	#)
	pass
