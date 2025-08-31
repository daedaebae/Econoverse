extends Node

# TODO: Use main.gd to preloa/load/run assets, resources, scripts, and others 
#		items as needed or at compile time.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Godot loads the Resource when it reads this very line.
	var imported_resource = preload("res://resources/Items.json")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
