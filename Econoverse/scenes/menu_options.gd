extends Control

@onready var menu_paused: Control = $MenuPaused
@onready var menu_options: Control = $MenuOptions
@export var resolution_option: OptionButton
@export var player_name_debug: LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_tree().paused = false   #this can be controlled elsewhere.
	menu_paused.hide()
	menu_options.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	pass

func _on_button_continue_pressed() -> void:
	menu_paused.hide()
	get_tree().paused = false
	
func _on_button_options_pressed() -> void:
	menu_paused.hide()
	menu_options.show()

func _on_button_quit_pressed() -> void:
	get_tree().quit()
	
func _on_button_back_pressed() -> void:
	menu_options.hide()
	menu_paused.show()

func _on_input_name_text_submitted(new_text: String) -> void:
	Globals.set("player_name", player_name_debug.text)
	player_name_debug.text = "PlayerName: " + str(Globals.player_name)
	player_name_debug.text = ""
	print("Player name changed to: " + str(Globals.player_name))
	

func _on_option_button_resolution_item_selected(index: int) -> void:
 #kc 9/8/25 retrieves the resolution option button metadata 
 #and sets the resolution override. 
	# Get the selected resolution from the item's metadata
	var new_resolution_vector2i = resolution_option.get_item_metadata(index)
	DisplayServer.window_set_size(new_resolution_vector2i)
	print("DisplayServer window size changed to:" + str(new_resolution_vector2i))
	 

func _on_check_box_fullscreen_toggled(toggled_on: bool) -> void:
	# Check if the checkbox is checked (toggled_on is true).
	if toggled_on:
		# Set the window to fullscreen mode.
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		# If unchecked, set the window back to windowed mode.
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
