#GDScript to extend Inventory Object within Character Object

@tool
class_name Inventory

# DONE: need getters and setters
@export var _content: Item_Resource
#var all_items = preload("res://assets/Items.json")
#@export var all_items: Array[Item_Resource] = []
#@export var all_items: Array = []


#FIXME: durf 10/23/25 - fix these functions to manipulate the inventory.
# Show
#func show_item(item:Item):
	#_content.

func add_item(item:Item):
	#_content.???
	pass

func remove_item(item:Item):
	#_content.erase(item)
	pass

func get_item(item:Item):
	#return _content
	pass
