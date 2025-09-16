extends Control
## kc 9/16/25 7:30pm; preparing to write the psuedocode 
## for the main menu screen implementation. 
# TODO: PUSHING OUT TO V2: Still need to have a robust options menu to traverse and
# save settings locally for the user. 

#import all assets that will be manipulated by main scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
	
	
