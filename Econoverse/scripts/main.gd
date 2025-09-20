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
	var imported_resource = preload("res://resources/Items.json")
	#preload("res://scripts/worldclock.gd")
	test_shit("Player",Player)
	test_shit("Smith",Smith)
	test_shit("Baker",Baker)
	print("end")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# FIXME: DEBUG
func test_shit(Test, CharIn):
	print("####################\n\ttesting_shit\n####################")
	print(
		str(Test),
		"\nname: ", CharIn.char_name,
		"\nlocation: ",CharIn.location,
		"\ngender: ",CharIn.gender,
		"\nrace: ",CharIn.race,
		"\ninventory:\n\t\t[Sword: ",CharIn.inventory.Sword,
		"] [Strudel: ",CharIn.inventory.Strudel,"] [Coins: ",CharIn.inventory.Coins,
		"] ",
		"\nprofession: ",CharIn.profession
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
