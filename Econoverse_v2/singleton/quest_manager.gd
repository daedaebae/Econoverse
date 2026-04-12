extends Node
#region Explanation
# connected to quest manager scene for review of it's properties via inspector.
	# Registered as a .tscn autoload so QuestManager can leverage child nodes
	# (timers for deadlines, debug overlays for quest state) and expose
	# configuration through the Inspector as the system grows.
	# Inspector — could expose quest state and configuration with proper controls as the system grows.
	# Child nodes — if we need timers for deadline checks or audio cues, they can be added in the editor instead of code.
	# Debug UI — a CanvasLayer overlay for viewing quest state could live here, toggled by a key, without touching other scenes.
# QuestManager does not:
	# - hold inactive or undiscovered quests — it only knows what's currently live
	# - interpret events — it only fires them, listeners decide what they mean
	# - reference NPCs or UI — all communication flows through signals
	# - render anything — UI listens to QuestManager, not the other way around
#endregion

#region Exports
@export_group("State")
@export var active_quests 		: Dictionary
@export var completed_quests	: Array[String] #Quest IDs that finished successfully
@export var failed_quests		: Array[String] #Quest IDs that expired or failed  
#endregion

#region Signals Emitted
signal quest_started(quest_id)
signal quest_progress(quest_id, objective_id, current, required)
signal quest_completed(quest_id)
signal quest_failed(quest_id)
#endregion

func _ready() -> void:
	GameController.inventory_changed.connect(_on_trade_complete)
	WorldClock.time_changed.connect(_on_time_changed)

#region Methods
func activate_quest(quest: Quest):
	pass

func _on_trade_complete(trade: Dictionary):
	pass

func _check_completion(quest_id):
	pass

func _on_time_changed(day, hour, minute):
	pass


#endregion
