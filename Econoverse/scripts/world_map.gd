extends Control

# TODO: remove all the signals from the buttons. Maybe via this script?

# TODO: This region may be set up wrong--Finish mapping tiles to sprites on 
#		world map.

#region TileMapping
#@onready	 var tile_map : TileMap = $WorldMap/MasterStack/TileMapLayer

var smith_shop
#var stable_shop = tile_map.get_cell_atlas_coords(0,Vector2i(7,0),false) 
#var baker_shop = tile_map.get_cell_atlas_coords(0,Vector2i(5,0),false) 
#var tanner_shop = tile_map.get_cell_atlas_coords(0,Vector2i(2,0),false) 
#var mason_shop = tile_map.get_cell_atlas_coords(0,Vector2i(11,0),false) 
#var brewer_shop = tile_map.get_cell_atlas_coords(0,Vector2i(0,0),false) 
#var carpenter_shop = tile_map.get_cell_atlas_coords(0,Vector2i(9,0),false) 
#var market_square = tile_map.get_cell_atlas_coords(0,Vector2i(4,0),false) 

#endregion

#region Show Menu
@onready var world_map: Control = $WorldMap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_tree().paused = false   #this can be controlled elsewhere.
	world_map.hide()

func _input(event):
	# kc 9/6/25 moved to MAIN script.
	pass
#endregion
