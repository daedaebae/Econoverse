extends Control

# ledger.gd is the economy.
# Things it will track:
	# current location of each item
	# history of price of each item
	# logs of where, how, how much of an item moved and at what price, how the prices changed during the move
# This ledger will be registered with the game_controller and will be called upon as the source of truth for prices,
# transactions, and rates.
#TODO: durf - need to connect all the values within the ledger.

# Register the ledger with the game contoller
func _ready() -> void:
	GameController.register_ledger(self)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
