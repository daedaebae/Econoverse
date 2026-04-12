extends Node
# TODO: item matching uses string keys ("Coin") — migrate to ItemResource IDs
# when inventory system is updated. Affects Character, Ledger, PROFESSION_ITEM.
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

func activate_quest(quest: Quest) -> void:
	if quest.id in active_quests:
		Logging.log_warn("QuestManager: quest '%s' is already active." % quest.id)
		return
	var objectives_progress := {}
	for objective in quest.objectives:
		objectives_progress[objective.id] = 0
	active_quests[quest.id] = {
		"resource": quest,
		"start_day": WorldClock.day,
		"objectives_progress": objectives_progress,
	}
	Logging.log_info("Quest started: %s" % quest.title)
	quest_started.emit(quest.id)

func _on_trade_complete(trade: Dictionary) -> void:
	for quest_id in active_quests:
		var quest_data = active_quests[quest_id]
		var quest: Quest = quest_data.resource
		for objective in quest.objectives:
			# Match: did this trade involve the objective's target NPC?
			if objective.target_id == trade.tradee_id:
				# TODO: item matching uses string keys — see top of file
				var progress = quest_data.objectives_progress[objective.id]
				progress += trade.val_give
				quest_data.objectives_progress[objective.id] = progress
				Logging.log_info("Quest progress: %s — %s: %d / %d" \
					% [quest.title, objective.id, progress, objective.required_quantity])
				quest_progress.emit(quest_id, objective.id, progress, objective.required_quantity)
		_check_completion(quest_id)

func _check_completion(quest_id: String) -> void:
	var quest_data = active_quests[quest_id]
	var quest: Quest = quest_data.resource
	for objective in quest.objectives:
		if quest_data.objectives_progress[objective.id] < objective.required_quantity:
			return
	# All objectives met
	if quest.completion_event:
		quest.completion_event.fire({"quest_id": quest_id})
	active_quests.erase(quest_id)
	completed_quests.append(quest_id)
	Logging.log_info("Quest completed: %s" % quest.title)
	quest_completed.emit(quest_id)

func _on_time_changed(day: int, hour: int, minute: int) -> void:
	var expired := []
	for quest_id in active_quests:
		var quest_data = active_quests[quest_id]
		var quest: Quest = quest_data.resource
		if quest.days_to_complete <= 0:
			continue
		if day - quest_data.start_day >= quest.days_to_complete:
			expired.append(quest_id)
	for quest_id in expired:
		var quest_data = active_quests[quest_id]
		var quest: Quest = quest_data.resource
		if quest.failure_event:
			quest.failure_event.fire({"quest_id": quest_id})
		active_quests.erase(quest_id)
		failed_quests.append(quest_id)
		Logging.log_info("Quest failed: %s — deadline expired." % quest.title)
		quest_failed.emit(quest_id)

#endregion
