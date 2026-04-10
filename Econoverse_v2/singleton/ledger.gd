extends Control

# This ledger is the source of truth for the economy.
# It tracks:
#   - Total world supply of each commodity
#   - History of prices over time
#   - Log of all transactions

# --- World Supply ---
# The total quantity of each commodity that exists across all characters in the world.
# The sum of every character's inventory for a given item should equal its world supply.

 # TODO: Change later, starting with small numbers to test the flow of commodities.
const WORLD_SUPPLY: Dictionary = {
	"Boots":   100,
	"Coins":   1000,
	"Corn":    1000,
	"Horses":  100,
	"Timber":  1000,
	"Stone":   1000,
	"Strudel": 50,
	"Sword":   50,
	"Whiskey": 50,
}

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

# Returns the total world supply for a given item.
func get_world_supply(item: String) -> int:
	return WORLD_SUPPLY.get(item, 0)

# Sums the current inventory of every registered character (player + all artisans).
# Returns a dictionary of item → total currently held across the world.
func get_current_distribution() -> Dictionary:
	var distribution: Dictionary = {}
	for item in WORLD_SUPPLY:
		distribution[item] = 0

	if GameController.player_node:
		for item in GameController.player_node.inventory:
			if item in distribution:
				distribution[item] += GameController.player_node.inventory[item]

	for artisan in GameController.artisan_nodes:
		for item in artisan.inventory:
			if item in distribution:
				distribution[item] += artisan.inventory[item]

	return distribution

# Compares current distribution against WORLD_SUPPLY.
# Logs warnings for any item whose distributed total does not match the defined world supply.
func verify_supply() -> void:
	var dist = get_current_distribution()
	var all_ok := true
	for item in WORLD_SUPPLY:
		var expected = WORLD_SUPPLY[item]
		var actual = dist.get(item, 0)
		if actual != expected:
			Logging.log_warn("Supply mismatch — %s: expected %d, found %d (diff: %+d)" \
				% [item, expected, actual, actual - expected])
			all_ok = false
		else:
			Logging.log_info("Supply OK — %s: %d" % [item, actual])
	if all_ok:
		Logging.log_info("World supply verified: all commodities balanced.")

# Called by GameController when a trade completes.
# TODO: store trade history, update price tracking.
func track(trade: Dictionary) -> void:
	Logging.log_info("Ledger tracked trade: %s gave %d %s | %s gave %d %s" % [
		trade.get("trader", "?"), trade.get("val_give", 0), trade.get("item_give", "?"),
		trade.get("tradee", "?"), trade.get("val_get", 0), trade.get("item_get", "?")
	])
