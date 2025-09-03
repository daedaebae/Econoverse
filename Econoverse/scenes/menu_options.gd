extends Control

@onready var menu_paused: Control = $MenuPaused
@onready var menu_options: Control = $MenuOptions

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_tree().paused = false   #this can be controlled elsewhere.
	
	menu_paused.hide()
	menu_options.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if Input.is_action_just_pressed("exit"):
		if menu_paused.visible:
			#TODO tween fade-out alpha for menu.
			menu_paused.hide()
			get_tree().paused = false
		elif menu_options.visible:
			#TODO tween fade-out alpha for menu.
			menu_options.hide()
			menu_paused.show()
		else:
			#TODO tween fade-in alpha for menu. 
			menu_paused.show()
			get_tree().paused = true

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
