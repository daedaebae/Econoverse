extends Node

@onready var coin_header = $CurrencyStack/CoinHeader
@export var coin_counter : Label
var item_coin = preload("res://resources/ItemCoin.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var coin_container = coin_header.get_children()[0] 
	coin_container.set_item(item_coin)
	$CurrencyStack/CoinHeader/Counter.text = str(set_currency(1000000))

# Currency converter
func convert_copper_to_currency(copper: int) -> Dictionary:
	# Calculate the number of gold pieces (100 copper per silver, 100 silver per gold)
	var gold = int(copper / 10000)
	# Calculate the remaining copper after extracting gold
	var remaining = copper % 10000
	# Calculate the number of silver pieces (100 copper per silver)
	var silver = int(remaining / 100)
	# Calculate the remaining copper after extracting silver
	var copper_final = remaining % 100
	
	# Return the result as a dictionary
	return {
		"gold": gold,
		"silver": silver,
		"copper": copper_final
	}
	
# Set coin values after converting from copper and display each as string.
func set_currency(amount: int) -> String:
	var gold = 0
	var silver = 0
	var copper = amount
	var currency = convert_copper_to_currency(amount)
	gold = str(currency.get('gold'))
	silver = str(currency.get('silver'))
	copper = str(currency.get('copper'))
	return gold
	
	
	#$CurrencyStack/CoinHeader/Counter.text = 'Gp'+gold+' Sp'+silver+' Cp'+copper

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	# DONE: kc 9/16/25 - Set this to a variable defined by currency generating events.
	#kc 9/16/25; prevents error overrun if Player has not yet been instantiated.
	if !Main.Player: 
		return
	else:
		coin_counter.text = str(Main.Player.inventory["Coins"],"")
	pass
