extends Control

# TODO: remove all the signals from the buttons. Maybe via this script?

@onready var commodities_menu: Control = $CommoditiesMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_tree().paused = false   #this can be controlled elsewhere.
	commodities_menu.hide()

func _input(event):
	if Input.is_action_just_pressed("commods"):
		if commodities_menu.visible:
			#TODO tween fade-out alpha for menu.
			commodities_menu.hide()
			get_tree().paused = false
		else:
			#TODO tween fade-in alpha for menu. 
			commodities_menu.show()
			get_tree().paused = true
