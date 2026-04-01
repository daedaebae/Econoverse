#takes the resource and divy up it's properties for quick review with
#generalized references, so this can be used with any tracker object quickly
extends HBoxContainer

@export var item_resource : Resource
@export var TrackerTexture: TextureRect
@export var LabelQty: Label

func _ready() -> void:
	#added defensible check, so this could work with or without all properties
	if TrackerTexture:
		TrackerTexture.texture = item_resource.texture
		TrackerTexture.tooltip_text = item_resource.get_tooltip()
	
func _process(delta: float) -> void:
	pass
	# track the quantity of the player's item here somehow something like:
	# LabelQty.text = Player.Inventory[item_resource.resource_name]
	
	# or (more performant) updated by signal:
	# in ready:
	# Player.inventory_changed.connect(_on_inventory_changed)
	
	# func(_on_inventory_changed) --> int: 
	# 	if Player.Inventory[item_resource.resource_name] != LabelQty.text
	# 		LabelQty.text = Player.Inventory[item_resource.resource_name]
	# 
	# could later do dynamic roll up/down of values with sfx for the juice
