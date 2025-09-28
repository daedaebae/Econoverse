extends Control
## kc 9/16/25 7:30pm; preparing to write the psuedocode 
## for the main menu screen implementation. 
# TODO: V2: Still need to have a robust options menu to traverse and
# save settings locally for the user. This config should be local to the system. 
# Beyond that, allow for multiple save files for the user, 
# and give debug options for save files (or a whole debug scene).

@export var song_intro : AudioStreamPlayer
@export var sfx_select : AudioStreamPlayer
@export var amb_air_night : AudioStreamPlayer
@export var button_options : Button
@export var user_backmenus : Control
@export var TopLayer : CanvasLayer
@export var menu_paused : Control
@export var menu_options : Control
@export var blur : Control
@export var BlackOut : ColorRect
var world_map = null
var commodities_menu = null
#@export var menu_audio : Control

#export all assets that will be manipulated by main scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	song_intro.play()
	amb_air_night.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	#have a function that, if the player select the start button:
	#animation which modulates the Start button 
	#(either recursively or by using the animation player timeline somehow) 
	#every other frame (half of the delta) until a span of time is met.
	#experiment with gold color and/or alpha modulation. 
	#review arcade game references. Prompt gemini for idea chiseling.
	
	#after the start button animation/modulation, 
	#simply fade out the TitleScreen elements 
	#then change the scene to main.
	
func _input(event):
# kc 9/17/25; pasted visibility scripts here, need to better localize these for instantiation and state control.
	#region TopLayer Menus
		# kc 9/6 added to ensure canvas layer is hidden if game isn't paused.
	if get_tree().paused == false:
		TopLayer.hide() 
		
	if Input.is_action_just_pressed("exit"):
		# Enable TopLayer and pause if not already TopLayer
		if !TopLayer.visible:
			blur.show()
			TopLayer.show()
			menu_paused.show()
			sfx_select.play()
			get_tree().paused = true
		# Close pause menu if visible
		elif menu_paused.visible:
			menu_paused.hide()
			TopLayer.hide()
			blur.hide()
			get_tree().paused = false
		# Close world map if visible
		#elif world_map.visible:
			#print("Map closed - exit key pressed")
			#world_map.hide()
			#TopLayer.hide()
			#get_tree().paused = false
		## Close commod menu if visible
		#elif commodities_menu.visible:
			#print("Commodities closed - exit key pressed")
			#commodities_menu.hide()
			#TopLayer.hide()
			#get_tree().paused = false
		## Go back to pause menu if options menu visible
		elif menu_options.visible:
			menu_options.hide()
			menu_paused.show()
		else:
			TopLayer.show()
			menu_paused.show()
			blur.show()
			get_tree().paused = true
			
	#endregion


#intro song plays again after a randomized delay
func _on_intro_1_finished() -> void:
	var rand_await_time = int(randf_range(5,15))
	await get_tree().create_timer(rand_await_time).timeout
	song_intro.play()
	

#play select sound, load Main scene, transition effects
func _on_button_start_button_down() -> void:
	sfx_select.play()
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(BlackOut, "modulate", Color.BLACK, 2)
	
	await sfx_select.finished
	
	get_tree().change_scene_to_file("res://scenes/MAIN.tscn")
	#if Globals.player_name == "":
		#prompt_user_for_name()
	#else:
	
	#begin transition out
	#await some time for sfx to play and menu to transition
	#allow player to quickly interrupt by clicking again? 
	#use Main singleton to call scene transition func
	
func prompt_user_for_name():
	#TODO: ideally would be a tween fading here and between other UI screens
	#get name input
	go_to_main_scene()

func go_to_main_scene():
	pass
	#transition here
