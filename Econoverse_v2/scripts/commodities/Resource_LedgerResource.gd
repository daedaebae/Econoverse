@tool
extends Resource
class_name LedgerResource

#TODO: 	durf - Update the dictionary to include all items and data points needing to be
# 		displayed within the ledger. Ledge could be displayed to player later,
#		but will be initially used as tooling for tracking item progressions.
@export var ledger = {
	"item1": "item1",
	"item2": "item2",
	"item3": "item3"
}
