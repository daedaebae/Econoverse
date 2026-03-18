extends Control

# the primary on-screen UI to arrange buttons and their signal logic

# the UI does not perform functions for any gameplay. It is simply the display
# and characterization of the data with which we want to present to the player.
# This can be for celebration accomplishments, driving interest in certain
# gameplay elements, or nudging the player to successful strategies

# list all exports, including references to buttons and other dynamic elements
@export var button_ledger: TextureButton
@export var button_music_player: TextureButton

# signals:
# list all button pressed signals here, for other functions and game mechanics
# to access. we can create custom signals from scratch and determine their 
# logic freely, and use the signals provided on nodes for triggered expected 
# behaviors. 

signal ButtonLedgerPressed
signal ButtonMusicPlayerPressed

func _ready() -> void:
	pass
	
	# list any inbound signal connections here, to ensure the scene is ready
	# maybe there is a signal to pass user preferences in for the UI. another
	# script may store user preferences in place. ui script could listen for it.

func _process(delta: float) -> void:
	pass
	# state machine to handle a combination of UI elements on screen
	# review gameplay of other UI-rich games -- static or moveable windows?

# various button pressed functions to emit their signals and enable various
# functions and mechanics to kick off

func _on_button_ledger_button_down() -> void:
	emit_signal("ButtonLedgerPressed")
