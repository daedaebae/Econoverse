extends Control

# ledger.gd is the economy.
# Things it will track:
	# current location of each item
	# history of price of each item
	# logs of where, how, how much of an item moved and at what price, how the prices changed during the move
# This ledger will be registered with the game_controller and will be called upon as the source of truth for prices,
# transactions, and rates.

# Register the ledger with the game contoller
func _ready() -> void:
	GameController.register_ledger(self)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#TODO: Update ledger here or in the game controller?
	#update_ledger() function to check for trades and track.
	pass

# ui menu node labels
@export var target_label: Label

# --- Sound ---
@onready var sound_show: AudioStreamPlayer = $SfxPapyrusOpen
@onready var sound_hide: AudioStreamPlayer = $SfxPapyrusClose
@onready var sound_plus: AudioStreamPlayer = $SfxIncrement
@onready var sound_minus: AudioStreamPlayer = $SfxDecrement

# These variables will store the current trade details
@onready var when_traded: int = 0
@onready var who_traded1: Character
@onready var who_traded2: Character
@onready var item_traded1: Item
@onready var item_traded2: Item
@onready var item_price1: int = 0
@onready var item_price2: int = 0
@onready var item_amount1: int = 0
@onready var item_amount2: int = 0


# These store WHO is trading
var player_node: Node = null
var npc_node: Node = null

# This is the main function you'll call from your Player
# to open and set up the trade window.

#TODO: If L pressed again close the menu
func _input(event):
	if event.is_action_pressed("open_ledger"):
		show()
		sound_show.play()
	
# A helper function to set label values
#TODO: move this function to global to use everywhere
func _update_label(Label, label_text):
	Label.text = label_text

# --- Signal Connections ---
func _on_button_cancel_pressed() -> void:
	hide()
	sound_hide.play()

func _on_button_last_page_pressed() -> void:
	#TODO: update page number label
	#_update_labels()
	sound_minus.play()

func _on_button_next_page_pressed() -> void:
	#TODO: update page number label
	#_update_labels()
	sound_minus.play()
	
#TODO: All buttons below signal header buttons within the ledger to sortby that
#	   button's value.
func _on_button_sort_by_when_pressed() -> void:
	#TODO: update page number label
	#_update_labels()
	sound_minus.play()

func _on_button_sort_by_who1_pressed() -> void:
	#TODO: update page number label
	#_update_labels()
	sound_minus.play()
	
func _on_button_sort_by_who2_pressed() -> void:
	#TODO: update page number label
	#_update_labels()
	sound_minus.play()
	
func _on_button_sort_by_item1_pressed() -> void:
	#TODO: update page number label
	#_update_labels()
	sound_minus.play()
	
func _on_button_sort_by_item2_pressed() -> void:
	#TODO: update page number label
	#_update_labels()
	sound_minus.play()
	
func _on_button_sort_by_amount1_pressed() -> void:
	#TODO: update page number label
	#_update_labels()
	sound_minus.play()
	
func _on_button_sort_by_amount2_pressed() -> void:
	#TODO: update page number label
	#_update_labels()
	sound_minus.play()
	
func _on_button_sort_by_price1_pressed() -> void:
	#TODO: update page number label
	#_update_labels()
	sound_minus.play()

func _on_button_sort_by_price2_pressed() -> void:
	#TODO: update page number label
	#_update_labels()
	sound_minus.play()
