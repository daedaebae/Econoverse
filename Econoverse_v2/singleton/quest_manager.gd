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

var quest_game_start: Quest = preload("res://scripts/quests/quest bundles/000 - game_start/quest_game_start.tres")
var quest_first_meeting: Quest = preload("res://scripts/quests/quest bundles/001 - first_meeting/quest_first_meeting.tres")
var quest_threes_company: Quest = preload("res://scripts/quests/quest bundles/002 - threes_company/quest_threes_company.tres")

# event_id -> Array[Quest] to activate when that event fires
var quest_triggers: Dictionary = {
	"quest_trigger_first_meeting": [quest_first_meeting, quest_threes_company],
}

func _ready() -> void:
	GameController.inventory_changed.connect(_on_trade_complete)
	GameController.character_met.connect(_on_character_met)
	WorldClock.time_changed.connect(_on_time_changed)
	# Game start quest activates immediately
	activate_quest(quest_game_start)
	# Listen for events that trigger other quests
	_connect_quest_triggers()

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

#region Signal Handlers — standardize data and route to _evaluate_event

func _on_trade_complete(trade: Dictionary) -> void:
	# GIVE — what the player gave to the NPC
	_evaluate_event(QuestObjective.ObjectiveType.GIVE, {
		"target_id": trade.tradee_id,
		"item_id": trade.item_give,
		"quantity": trade.val_give,
	})
	# GET — what the player received from the NPC
	_evaluate_event(QuestObjective.ObjectiveType.GET, {
		"target_id": trade.tradee_id,
		"item_id": trade.item_get,
		"quantity": trade.val_get,
	})

func _on_character_met(character_id: String) -> void:
	_evaluate_event(QuestObjective.ObjectiveType.MEET, {
		"target_id": character_id,
		"quantity": 1,
	})

#endregion

#region Core Evaluation — one path for all objective types

func _evaluate_event(event_type: int, data: Dictionary) -> void:
	var to_check := []
	for quest_id in active_quests.keys():
		var quest_data = active_quests[quest_id]
		var quest: Quest = quest_data.resource
		for objective in quest.objectives:
			if objective.objective_type != event_type:
				continue
			if not _matches_target(objective, data):
				continue
			_update_progress(quest_id, quest, objective, quest_data, data)
		to_check.append(quest_id)
	for quest_id in to_check:
		if quest_id in active_quests:
			_check_completion(quest_id)

func _matches_target(objective: QuestObjective, data: Dictionary) -> bool:
	var target = objective.target_id
	# Wildcards — match any target of the right event type
	if target == "any_character" or target == "any_item":
		return true
	# Exact match against event data
	return target == data.get("target_id", "")

func _update_progress(quest_id: String, quest: Quest, objective: QuestObjective, quest_data: Dictionary, data: Dictionary) -> void:
	var progress = quest_data.objectives_progress[objective.id]
	progress += data.get("quantity", 1)
	quest_data.objectives_progress[objective.id] = progress
	Logging.log_info("Quest progress: %s — %s: %d / %d" \
		% [quest.title, objective.id, progress, objective.required_quantity])
	quest_progress.emit(quest_id, objective.id, progress, objective.required_quantity)

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

#endregion

func _connect_quest_triggers() -> void:
	for event_id in quest_triggers:
		# Find the EventResource across all preloaded quests' completion/failure events
		var event_resource := _find_event_resource(event_id)
		if event_resource:
			event_resource.triggered.connect(_on_quest_trigger_event)
		else:
			Logging.log_warn("QuestManager: no EventResource found for trigger '%s'" % event_id)

func _find_event_resource(event_id: String) -> EventResource:
	# Search all preloaded quests for a matching event
	for quest in [quest_game_start, quest_first_meeting, quest_threes_company]:
		if quest.completion_event and quest.completion_event.id == event_id:
			return quest.completion_event
		if quest.failure_event and quest.failure_event.id == event_id:
			return quest.failure_event
	return null

func _on_quest_trigger_event(event_data: Dictionary) -> void:
	var event_id = event_data.get("event_id", "")
	if event_id in quest_triggers:
		for quest in quest_triggers[event_id]:
			if quest.id not in active_quests and quest.id not in completed_quests \
				and quest.id not in failed_quests:
				activate_quest(quest)

func _on_time_changed(day: int, hour: int, minute: int) -> void:
	_evaluate_event(QuestObjective.ObjectiveType.ELAPSE, {
		"target_id": "world_clock",
		"quantity": 1,
	})

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

func validate_quest_state() -> void:
	var issues := 0
	# Check that every triggered quest landed somewhere
	for event_id in quest_triggers:
		for quest in quest_triggers[event_id]:
			var in_active = quest.id in active_quests
			var in_completed = quest.id in completed_quests
			var in_failed = quest.id in failed_quests
			if not in_active and not in_completed and not in_failed:
				Logging.log_warn("Quest '%s' expected from trigger '%s' — not found anywhere." \
					% [quest.id, event_id])
				issues += 1
	# Check for orphans — active quests with no trigger entry
	for quest_id in active_quests:
		var found := false
		for event_id in quest_triggers:
			for quest in quest_triggers[event_id]:
				if quest.id == quest_id:
					found = true
					break
		if not found:
			Logging.log_warn("Quest '%s' is active but has no trigger entry." % quest_id)
			issues += 1
	if issues == 0:
		Logging.log_info("Quest validation passed: %d active, %d completed, %d failed." \
			% [active_quests.size(), completed_quests.size(), failed_quests.size()])
	else:
		Logging.log_error("Quest validation found %d issue(s)." % issues)

#endregion
