extends Control

# TODO: remove all the signals from the buttons. Maybe via this script?

@onready var commodities_menu: Control = $CommoditiesMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_tree().paused = false   #this can be controlled elsewhere.
	commodities_menu.hide()

func _input(event):
	#kc 9/6/25 moved to MAIN script
	pass
