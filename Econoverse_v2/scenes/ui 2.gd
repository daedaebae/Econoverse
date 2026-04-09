extends Control

# the primary on-screen UI to arrange interface buttons and their signal logic
# kc 03/31/2026
# the UI does not perform functions for any gameplay. It is simply the display
# and characterization of the data with which we want the player to experience.
# This can be for celebrating accomplishments, driving interest in certain
# gameplay elements, or nudging the player to successful strategies. Provide
# the player with visual tools to personalize and progress, and review 
# their experience.

#TODO kc - configure notifications and popup systems
#TODO kc - 9 patch rect outlines art
#TODO kc - determine where to use collapsable containers, vsplit or hsplit
#TODO kc - subviewport container for notifications (ala stronghold events)
#TODO kc - replace placeholder emojis with actual sprite art
#TODO kc - consider texture rect buttons, better feel and response
#TODO kc - integrate sound handling for butons only. press and release sounds for juicy feel. UI/action appears on release of buttons.

var label_time: Label

@export_category("Info Cluster")
# moved scripts to be local to cluster, so each tracker can update dynamically. 

# list all exports, including references to buttons and other dynamic elements
@export_category("Buttons")
@export var button_ledger: Button
@export var button_music_player: Button

@export_category("Menus")
@export var music_controller: Control
# this will be helpful to list any menus, to help along state machine logic.

# signals:
# list all button pressed signals here, for other functions and game mechanics
# to access. we can create custom signals from scratch and determine their 
# logic freely, and use the signals provided on nodes for triggered expected 
# behaviors. 

signal ButtonLedgerPressed
signal ButtonMusicPlayerPressed

func _ready() -> void:
	WorldClock.time_changed.connect(_on_time_changed)
	call_deferred("_set_initial_time")


func _set_initial_time() -> void:
	label_time = find_child("LabelTime", true, false)
	if label_time:
		label_time.text = WorldClock.get_time_string()
	
	# list any inbound signal connections here, to ensure the scene is ready
	# maybe there is a signal to pass user preferences in for the UI. another
	# script may store user preferences in place. ui script could listen for it.


func _process(delta: float) -> void:
	pass
	#TODO kc 3/22/26: need to make player inventory amounts global
	#if player: 
		#label_coin_quantity.text = player.coins
	
	# state machine to handle a combination of UI elements on screen
	# review gameplay of other UI-rich games -- static or moveable windows?

func _on_time_changed(_day: int, _hour: int, _minute: int) -> void:
	if label_time:
		label_time.text = WorldClock.get_time_string()

# various button pressed functions to emit their signals and enable various
# functions and mechanics to kick off

func _on_button_ledger_button_down() -> void:
	#explicitly call the singleton signal, so it's global
	UI.ButtonLedgerPressed.emit()


func _on_button_music_player_button_down() -> void:
	#explicitly call the singleton signal, so it's global
	UI.ButtonMusicPlayerPressed.emit()
