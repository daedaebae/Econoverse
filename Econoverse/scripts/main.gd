extends Node

# TODO: Use main.gd to preload/load/run assets, resources, scripts, and other
#		items as needed or at compile time.
# TODO: Continue migrating everything to main


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Godot loads the Resource when it reads this very line.	
	var imported_resource = preload("res://resources/Items.json")
	preload("res://scripts/worldclock.gd")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# TODO: Location State Machine

#region Location State-Machine
enum Location {
	
}
#endregion
