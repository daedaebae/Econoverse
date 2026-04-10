extends Control

##kc 10/24/25; could also add a separate UI 'breakout' window that
##displays the inventory of the player, and a separate one for npc character?

# --- Node References ---
# We get these nodes so we can update their text
@export var title_label: Label
@export var give_item_label: Label
@export var give_amount_label: LineEdit
@export var get_item_label: Label
@export var get_amount_label: LineEdit

# ?
@export var npc_resource: Resource

# ?
@export var item_resource_list: Array[Resource]
@export var give_item_sprite: TextureRect
@export var get_item_sprite: TextureRect

# ?
var item_keys: Array = []
var give_item_index: int = 0
var get_item_index: int = 0

# --- Sound ---
##kc 10/26/25; began basic sfx implementation. Not the most
## rigid yet. Also considering variations based on
## signal values and extensible game logic.
@onready var sound_show: AudioStreamPlayer = $SfxPapyrusOpen
@onready var sound_hide: AudioStreamPlayer = $SfxPapyrusClose


@onready var sound_plus: AudioStreamPlayer = $SfxIncrement
@onready var sound_minus: AudioStreamPlayer = $SfxDecrement

## 10/26/25; these need to specifically react to
## trade criteria and signals for successful or failed trades.
#@export var sound_trade_complete: AudioStreamPlayer
#@export var sound_trade_fail: AudioStreamPlayer

# --- Trade State ---
# These variables will store the current trade details
var current_give_amount: int = 0
var current_get_amount: int = 0
var current_item_give: String = ""
var current_item_get: String = ""
var resource_map: Dictionary = {}


# These store WHO is trading
var player_node: Node = null
var npc_node: Node = null

func _ready():
	# kc 10/25/25; assign the trade ui to the gamecontroller singleton
	GameController.register_trade_ui(self)

# This is the main function you'll call from your Player
# to open and set up the trade window.

##kc 10/24/25; this could be a useful place to get player/npc names.
func open_trade(player: Node, npc: Node, item_give: String, item_get: String):
	# ?
	for res in item_resource_list:
		resource_map[res.name_full] = res
		
	# Store all the trade information
	self.player_node = player
	self.npc_node = npc
	item_keys = player_node.inventory.keys()
	give_item_index = 0
	get_item_index = 0
	current_item_give = item_keys[give_item_index]
	current_item_get = item_keys[get_item_index]
	current_give_amount = 0
	current_get_amount = 0
	_update_labels()
	show()
	sound_show.play()
	
#region cycling
# Allow cycling through items within the UI-Trade menu
func _on_button_give_prev_pressed() -> void:
	give_item_index = (give_item_index - 1 + item_keys.size()) % item_keys.size()
	current_item_give = item_keys[give_item_index]
	current_give_amount = 0
	_update_labels()

func _on_button_give_next_pressed() -> void:
	give_item_index = (give_item_index + 1) % item_keys.size()
	current_item_give = item_keys[give_item_index]
	current_give_amount = 0
	_update_labels()

func _on_button_get_prev_pressed() -> void:
	get_item_index = (get_item_index - 1 + item_keys.size()) % item_keys.size()
	current_item_get = item_keys[get_item_index]
	current_get_amount = 0
	_update_labels()

func _on_button_get_next_pressed() -> void:
	get_item_index = (get_item_index + 1) % item_keys.size()
	current_item_get = item_keys[get_item_index]
	current_get_amount = 0
	_update_labels()

#endregion cycling

# TODO: durf- set the sprite for this artisan based on the artisan
# chosen in this function
	

	# Reset amounts
	current_give_amount = 0
	current_get_amount = 0

	# Update labels and show the window
	_update_labels()
	show()
	sound_show.play()

# A helper function to keep all our labels in sync
func _update_labels():
	title_label.text = "Trading\n" + str(npc_node.profession) + "\n" +  str(npc_node.char_name)

	# Replacing for cycling sprites
	give_item_sprite.texture = resource_map[current_item_give].texture
	#give_item_label.text = "You Give: %s" % current_item_give
	give_amount_label.text = str(current_give_amount)

	# Replacing for cycling sprites
	get_item_sprite.texture = resource_map[current_item_get].texture
	#get_item_label.text = "You Get: %s" % current_item_get
	get_amount_label.text = str(current_get_amount)


# --- Signal Connections ---
func _on_button_trade_pressed() -> void:
	current_give_amount = give_amount_label.text.to_int()
	current_get_amount = get_amount_label.text.to_int()
	# Call the player's trade function AND set the output as a "success" bool var.
	# Trade function now outputs true/false to show if trade is possible errors.
	if current_give_amount == 0 and current_get_amount == 0:
		%LabelDenied.text = "Set an amount first."
		%LabelDenied.show()
		return
	var success = player_node.trade(npc_node, current_give_amount, current_item_give, current_get_amount, current_item_get)
	if success:
		# Close the UI after the trade
		%LabelDenied.hide()
		#TODO: kc 10/26/25; for now, this will simply play the
		# close window sound. Later, can play specific sounds
		# for if trade was successful or declined... or crit? idk
		sound_hide.play()
		hide()
	else:
		%LabelDenied.text = "Ye fool! Ye can't trade what ye don't have!"
		%LabelDenied.show()
		current_give_amount = 0
		current_get_amount = 0
		_update_labels()
	




func _on_button_minus_get_pressed() -> void:
	current_get_amount = max(0, current_get_amount - 1)
	_update_labels()
	sound_minus.play()


func _on_button_plus_get_pressed() -> void:
	current_get_amount += 1
	# Add logic here to check if NPC has enough
	_update_labels()
	sound_plus.play()


func _on_button_cancel_pressed() -> void:
	hide()
	sound_hide.play()


func _on_button_minus_give_pressed() -> void:
	current_give_amount = max(0, current_give_amount - 1)
	_update_labels()
	sound_minus.play()


func _on_button_plus_give_pressed() -> void:
	current_give_amount += 1
	# Add logic here to check if player has enough
	_update_labels()
	sound_plus.play()
	
func _on_give_amount_label_text_changed(new_text: String) -> void:
	current_give_amount = max(0, new_text.to_int())

func _on_get_amount_label_text_changed(new_text: String) -> void:
	current_get_amount = max(0, new_text.to_int())


func _on_label_amount_give_text_changed(new_text: String) -> void:
	pass # Replace with function body.


func _on_label_amount_get_text_changed(new_text: String) -> void:
	pass # Replace with function body.
