## kc 09/02/25 - I got rambly here -- trying to feel out the overall design! Writing this as ideation, since we're getting to a point that each system has data ready to be passed around. I'm sure I missed something. 
## durf 09/02/25 - 	Love rambly, this is very useful. When we meet 09/04 need to
##					talk more about how we can use GLOBALS. It looks like you 
##					were planning to use it the same way I was planning to use 
##					main.gd. I had the idea to us the Inventory class to as a
##					blueprint to show each character's Inventory. That may not
##					be the best way but it made sense when I wrote it ¯\_(ツ)_/¯

extends Node

var player_name : String = ""
#User input to determine this. Consider randomizer with funny preset names (stretch feature).
# var player_name_presets : String = ""

# func set_player_name(String):
	# would be called with LineEdit node to handle player input and set global.player_name

#var commodities : Dictionary = {
	#au = {
		#"id": 1,
		#"start_price": 1.00,
		#"name_full": "Gold",
		#"name_abbreviated": "Au",
		#"description": "The currency of the land. Used to purchase valuable goods.",
		#"texture": "",
		#"world_supply": 1000
	#},
	#wood = {
		#"id": 2,
		#"start_price":  1.00,
		#"name_full": "Lumber",
		#"name_abbreviated": "Wood",
		#"description": "Raw, unprocessed lumber used for construction and industry.",
		#"texture": "",
		#"world_supply": 1000
	#},
	#stone = {
		#"id": 3,
		#"start_price": 1.00,
		#"name_full": "Rock",
		#"name_abbreviated": "Stone",
		#"description": "Raw, unprocessed stone used for construction and industry.",
		#"texture": "",
		#"world_supply": 1000
	#},
	#whiskeh = {
		#"id": 4,
		#"start_price": 1.00,
		#"name_full": "Alcohol",
		#"name_abbreviated": "Whiskeh",
		#"description": "A low viscocity solvent used as a painkiller, cleaning and sterilizing agent, and most notably, liquid courage.",
		#"texture": "",
		#"world_supply": 1000
	#},
	#nay = {
		#"id": 5,
		#"start_price": 1.00,
		#"name_full": "Horses",
		#"name_abbreviated": "Nay",
		#"description": "A blue crystalline solid used in medicine and other industries.",
		#"texture": "",
		#"world_supply": 1000
	#},
	#corn = {
		#"id": 6,
		#"start_price": 1.00,
		#"name_full": "Corn",
		#"name_abbreviated": "Corn",
		#"description": "A sweet, yellow, starchy seed know for its many industrial applications and thus in some cultures, its fungibility.",
		#"texture": "",
		#"world_supply": 1000
	#},
	#boots = {
		#"id": 7,
		#"start_price": 1.00,
		#"name_full": "Boots",
		#"name_abbreviated": "Boots",
		#"description": "L-shaped leather protectants for your widdle toesies. Dont' ferget to earl 'em up!",
		#"texture": "",
		#"world_supply": 1000
	#},
	#ore = {
		#"id": 8,
		#"start_price": 1.00,
		#"name_full": "Metals",
		#"name_abbreviated": "Ore",
		#"description": "Types of raw and processed ores within the lands.",
		#"texture": "",
		#"world_supply": 1000
	#},
	#cloth = {
		#"id": 9,
		#"start_price": 1.00,
		#"name_full": "Textiles",
		#"name_abbreviated": "Cloth",
		#"description": "Different types of textiles used throught the land.",
		#"texture": "",
		#"world_supply": 1000
	#},
	#gems = {
		#"id": 10,
		#"start_price": 1.00,
		#"name_full": "Gemstones",
		#"name_abbreviated": "Gems",
		#"description": "Raw and processed stones mined and sold throughout the land.",
		#"texture": "",
		#"world_supply": 1000
	#},
	#food = {
		#"id": 11,
		#"start_price": 1.00,
		#"name_full": "Baked-goods",
		#"name_abbreviated": "Food",
		#"description": "Cooked foods and cooking ingredients sold throughout the land.",
		#"texture": "",
		#"world_supply": 1000
	#},
	#grain = {
		#"id": 12,
		#"start_price": 1.00,
		#"name_full": "Grains",
		#"name_abbreviated": "Grain",
		#"description": "Raw and processed stones mined and sold throughout the land.",
		#"texture": "",
		#"world_supply": 1000
	#}
#}

var player_inventory : Dictionary
# Could get/set this as needed for bartering/events. Will need functions use the global.player_currency variable. Just noticed you were working on a script separate for this, would work well separately!


var event_schedule : Dictionary = {
	'event_id' : 0,
	'execute_day' : 1,
	'execute_hour' : 1,
	'execute_minute' : 1,
}
#  A separate event manager script could get/set the values for the event schedule. A sort of front-desk assistant to pass around requests of NPC/Player/world events. This is not a quest manager for the player, but we could separately draw down from this schedule to create it specifically for the player. 
# If an event goes unhandled/errors for some reason, we could also capture that more locally through the event manager as well. Godot has custom error-handling, so we could specify what we're looking for in errors, and print your own custom message to nudge us in the right direction. 


var world_supply : Dictionary
# A finite supply of commodities could be determined. The values here are OUTSIDE of NPC/Player inventories, to be accessed mainly by NPCs and world events. Here is a great place to consider the overall game-loop, difficulty, pacing, and growth of gameplay. Maybe special events trigger when some commodities meet a certain threshold, and this is communicated to the player, then event manager kicks off a function to resupply or diminish that commodity. 


var world_demand : Dictionary
# Determines overall desire for each commodity. could be adjusted by ingame events or rng-based script. Here is where you can imagine the world economy fluctuate. 


## kc - Is this a good place for SOME game funcs to live as well? Those could be separated out among other scripts to be called globally, but you're really getting down to preference. In my learnings, when you get more specific and make more scripts, tracking down errors is way easier. 

## kc 09/02/25 - Here's Gemini's thinking on the above:

#Your code and notes show a great understanding of the core concepts for your game. Here are some suggestions to refine your approach and structure, building on what you have.
#
#📝 Global Variable Structure
#Your current global variables are a solid start. You're thinking about the core data: player info, events, and the economy. The variable names are clear and descriptive.
#
#💡 Organization and Best Practices
#You're considering a "game manager" script, which is the correct way to handle global state in Godot. Your notes are correct that it's a matter of preference on how much to put in a single script, but focusing on separation of concerns is key.
#
#Create a GameManager (or similar name) Singleton: This should be an AutoLoad in your project settings. It's the ideal place for all your global variables and the functions that manipulate them. This centralizes access to your game's state.
#
#Encapsulate Data and Logic: Instead of just having public variables, consider using get and set methods. This makes your code more robust and easier to debug later. For example:
#
#func get_player_inventory() -> Dictionary:
#
#func add_item_to_inventory(item_id: String, quantity: int):
#
#func check_supply(item_id: String) -> int:
#
#Modularize Your System: You're right to question putting everything in one script. While a GameManager handles the high-level state, consider creating separate singletons for more complex systems.
#
#EconomyManager: Could handle all logic related to world_supply, world_demand, price fluctuations, and transactions.
#
#EventManager: Could manage the event_schedule, triggering events and their effects.
#
#Your Note on Specificity is Spot-on: Having more, smaller scripts that each handle a single task (e.g., an EconomyManager) makes it much easier to track down bugs. If a price is wrong, you know exactly where to look.
#
#🎮 Game Loop and Pacing
#Your thought process about crafting and the game loop is excellent. Here's how your global variables fit into that:
#
#Centralized State: All parts of your game (NPCs, UI, events) can query the singletons for the current state of the world.
#
#Triggering Events: A WorldClock singleton could emit a signal every in-game day or week. Your EventManager would listen for this signal and check if there are any events scheduled for that time, then execute them.
#
#Dynamic Changes: The events triggered by the EventManager can call functions in the EconomyManager to change world_supply and world_demand, which would then dynamically alter prices for the player.
#
#Overall, your current setup is a fantastic starting point. The next step is to create the singletons and start building the logic to manage the data you've defined.
