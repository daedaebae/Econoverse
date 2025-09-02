# kc 09/02/25 - Try Print to test/track within console. This way you have one truth of the values, and you don't have the overhead of ensuring the UI is set up correctly and troubleshooting that too.

# TODO: Inventory class could be the parent used to generate a player/NPC's 
#		Inventory object and then rendered by the Inventory Node. That object 
#		contains item_slot objects that hold item objects (or we could just have
#		item_slots be a property of an Inventory object that can only be filled
#		by item objects).
#
#		item_slots may need to be a node as well so it can display the item
#		object it currently contains.

@tool
extends Resource
class_name Inventory

# TODO: need getters and setters?
var _content:Array[Item]: []

func add_item(item:Item):
	_content.append(item)

func remove_item(item:Item):
	_content.erase(item)

func get_item(item:Item):
	return _content
