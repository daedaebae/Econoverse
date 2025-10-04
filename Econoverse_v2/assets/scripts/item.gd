extends Resource

@export var itemName = ""
@export var itemDescription = ""
@export var itemImage = "res://item_images/default.png"
@export var itemCost = 0.0

func _ready():
	# Initialize image node
	#var spriteNode: Sprite = get_node("Sprite")
	#spriteNode.texture = load(itemImage)

	# Initialiize item node
	# GDScript does not have a direct equivalent of CS's GetItem function.
	# Assuming this line is supposed to set the item's sprite, it can be removed or replaced with the correct logic.
	# Trade item logic here
	#if get_node("Item").is_equipped:
		## Trade item
		#get_node("Item").trade_item()
	pass

func GetItemData():
	# Return item data as a dictionary
	return {
    "name": itemName,
    "description": itemDescription,
    "image": itemImage
	}

func TradeItem():
	# Trade item logic here
	# GD.print("Traded item: %s for %f" % [itemName, itemCost])
	pass
