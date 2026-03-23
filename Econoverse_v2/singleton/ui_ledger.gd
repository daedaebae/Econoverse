extends Control

# ledger.gd is the economy.
# Things it will track:
	# current location of each item
	# history of price of each item
	# logs of where, how, how much of an item moved and at what price, how the prices changed during the move
# This ledger will be registered with the game_controller and will be called upon as the source of truth for prices,
# transactions, and rates.

# Register the ledger with the game contoller
#TODO: append ledger to game log. 
func _ready() -> void:
	GameController.register_ledger(self)
	UI.ButtonLedgerPressed.connect(_toggle)
	call_deferred("_fix_scroll_mouse_filter")

	#TODO: Add: If game-save/game-log present: then don't set values
	# If new game then clean ledger
	clean_ledger()

func _fix_scroll_mouse_filter() -> void:
	var vbox := $LedgerDisplayBox/ScrollContainer/VBoxContainer
	vbox.mouse_filter = Control.MOUSE_FILTER_PASS
	for row in vbox.get_children():
		row.mouse_filter = Control.MOUSE_FILTER_PASS
		for child in row.get_children():
			child.mouse_filter = Control.MOUSE_FILTER_PASS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#TODO: Update ledger here or in the game controller?
	#update_ledger() function to check for trades and track.
	pass

# ui menu node labels
@export var target_label: Label

# Menu Sfx
@onready var sound_show: AudioStreamPlayer = $SfxPapyrusOpen
@onready var sound_hide: AudioStreamPlayer = $SfxPapyrusClose
@onready var sound_plus: AudioStreamPlayer = $SfxIncrement
@onready var sound_minus: AudioStreamPlayer = $SfxDecrement



# Variables for values of each node within a Row
@onready var when_traded: int = 0
@onready var who_traded1: Character
@onready var who_traded2: Character
@onready var item_traded1: Item
@onready var item_traded2: Item
@onready var item_price1: int = 0
@onready var item_price2: int = 0
@onready var item_amount1: int = 0
@onready var item_amount2: int = 0

func clean_ledger():
	var rows = %LedgerDisplayBox/ScrollContainer/VBoxContainer.get_children()
	print(rows)
	for row in rows:
		var labels = (row.get_children())
		print("\nlabels: ",labels,"\n")
		for label in labels:
			print("\nlabel: ",label,"\n")
			if label is Label:
				_update_label(label, "---")
			pass
	pass

func _input(event):
	if event.is_action_pressed("open_ledger"):
		_toggle()

func _toggle() -> void:
	if visible:
		hide()
		sound_hide.play()
	else:
		show()
		sound_show.play()
	
# A helper function to set label values
#TODO: move this function to global to use everywhere
func _update_label(Label, label_text):
	Label.text = label_text

# --- Signal Connections ---
func open_ledger() -> void:
	_toggle()
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
