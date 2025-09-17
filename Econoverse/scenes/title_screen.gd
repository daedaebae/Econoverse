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
	
	

#intro song plays again after a randomized delay
func _on_intro_1_finished() -> void:
	var rand_await_time = int(randf_range(5,15))
	await get_tree().create_timer(rand_await_time).timeout
	song_intro.play()
	

#play select sound, load Main scene, transition effects
func _on_button_start_button_down() -> void:
	sfx_select.play()
	#begin transition out
	#await some time for sfx to play and menu to transition
	#allow player to quickly interrupt by clicking again? 
	#use Main singleton to call scene transition func
