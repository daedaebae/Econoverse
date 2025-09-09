## kc -- you could have helper scripts on autoload, 
## then any script universally should be able to call your funcs.
#
## DONE: Consider deleting this script and just adding this function to main.
#extends Node
#
#var rng = RandomNumberGenerator.new()
#
## DONE: Need to test this function
#
#func roll_dice(count: int, sides: int) -> Array:
	#var results = []
	#for i in range(count):
		#results.append(rng.randi_range(1, sides))
	#return results
