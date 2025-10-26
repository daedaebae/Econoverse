extends Control

##kc 10/24/25; could also add a separate UI 'breakout' window that 
##displays the inventory of the player, and a separate one for npc character?

# --- Node References ---
# We get these nodes so we can update their text
@export var title_label: Label
@export var give_item_label: Label
@export var give_amount_label: Label
@export var get_item_label: Label
@export var get_amount_label: Label

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
	# Store all the trade information
	self.player_node = player
	self.npc_node = npc
	self.current_item_give = item_give
	self.current_item_get = item_get
	
	# Reset amounts
	current_give_amount = 0
	current_get_amount = 0
	
	# Update labels and show the window
	_update_labels()
	show()
	sound_show.play()

# A helper function to keep all our labels in sync
func _update_labels():
	title_label.text = "Trading with \n%s" % npc_node.char_name
	
	give_item_label.text = "You Give: %s" % current_item_give
	give_amount_label.text = str(current_give_amount)
	
	get_item_label.text = "You Get: %s" % current_item_get
	get_amount_label.text = str(current_get_amount)


# --- Signal Connections ---

func _on_button_trade_pressed() -> void:
	if current_give_amount == 0 and current_get_amount == 0:
		print("No trade specified.")
		return
		
	# Call the player's trade function!
	# We assume the 'trade' function is ON the player_node.
	if player_node and player_node.has_method("trade"):
		player_node.trade(npc_node, current_give_amount, current_item_give, current_get_amount, current_item_get)
		# Close the UI after the trade
		#TODO: kc 10/26/25; for now, this will simply play the 
		# close window sound. Later, can play specific sounds
		# for if trade was successful or declined... or crit? idk
		sound_hide.play()
		hide()

	else:
		print("Error: Player node not set or 'trade' function missing.")


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
