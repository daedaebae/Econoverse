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

# Clears all labels in the ledger display by setting their text to "---".
# Iterates through all rows and labels in the LedgerDisplayBox and updates them.
# Uncomment to print their values in logs
func clean_ledger():
	var rows = %LedgerDisplayBox/ScrollContainer/VBoxContainer.get_children()
	# print(rows)
	for row in rows:
		var labels = (row.get_children())
		#print statement for debug
		# print("\nlabels: ",labels,"\n")
		for label in labels:
			#print statement for debug
			# print("\nlabel: ",label,"\n")
			if label is Label:
				_update_label(label, "---")
			pass
	pass

func track(trade: Dictionary) -> void:
	#DEBUG Print Statements
	# Confirms track() was called and shows the full trade dictionary received.
	# If this doesn't print, ledger_node in GameController is null or wrong.
	print("[LEDGER] track() called with: ", trade)
	# Shows how many rows exist in the VBoxContainer before we try to populate one.
	# If this is 0, the scene node path is wrong or the scene hasn't loaded.
	print("[LEDGER] vbox children count: ", $LedgerDisplayBox/ScrollContainer/VBoxContainer.get_child_count())

	var vbox := $LedgerDisplayBox/ScrollContainer/VBoxContainer

	# Try to reuse first "---" row, otherwise duplicate the last row
	var target_row: Node = null
	for row in vbox.get_children():
		var labels = row.get_children()
		if labels.size() > 0 and labels[0] is Label and labels[0].text == "---":
			target_row = row
			break

	#DEBUG Print Statements
	# Shows whether an empty "---" row was found to reuse, or if a new one will be duplicated.
	# If null here AND vbox count was 0, row population will fail.
	print("[LEDGER] target_row found: ", target_row)

	if target_row == null:
		# Duplicate existing row as template
		target_row = vbox.get_child(0).duplicate()
		vbox.add_child(target_row)

	var cols = target_row.get_children()
	var time_str = WorldClock.get_time_string() if WorldClock else "?"
	var values = [
		time_str,
		trade.get("trader", "?"),
		trade.get("tradee", "?"),
		trade.get("item_give", "?"),
		trade.get("item_get", "?"),
		str(trade.get("val_give", 0)),
		str(trade.get("val_get", 0)),
		"---",  # price1 (not yet tracked)
		"---",  # price2 (not yet tracked)
	]

	#DEBUG Print Statements
	# Shows the final values array about to be written into the row labels.
	# If row doesn't update in-game but this prints correctly, the Label population loop has an issue.
	print("[LEDGER] Row populated with values: ", values)

	for i in range(min(cols.size(), values.size())):
		if cols[i] is Label:
			cols[i].text = values[i]

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
func _update_label(label, label_text):
	label.text = label_text

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
