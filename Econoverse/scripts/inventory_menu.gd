extends Control

# TODO: remove all the signals from the buttons. Maybe via this script?

@onready var inventory_menu: Control = $InventoryMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_tree().paused = false   #this can be controlled elsewhere.
	inventory_menu.hide()

func _input(event):
	if Input.is_action_just_pressed("Inventory"):
		if inventory_menu.visible:
			#TODO tween fade-out alpha for menu.
			inventory_menu.hide()
			get_tree().paused = false
		else:
			#TODO tween fade-in alpha for menu. 
			inventory_menu.show()
			get_tree().paused = true
