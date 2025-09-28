@tool
extends Control

@onready var texture_rect = $TextureRect
#@onready var name_label = $NameLabel
#@onready var rarity_border = $RarityBorder

@export var item_data : Item

func set_item(item : Item):
	item_data = item
	if item_data:
		texture_rect.texture = item_data.texture
		#name_label.text = item_data.display_name
		#rarity_border.modulate = item_data.get_rarity_color()
		self.tooltip_text = item_data.get_tooltip()
	else:
		print("no item on %$/.")
