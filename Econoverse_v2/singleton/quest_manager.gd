extends Node
# TODO: item matching uses string keys ("Coin") — migrate to ItemResource IDs
# when inventory system is updated. Affects Character, Ledger, PROFESSION_ITEM.

#region PolishRefactor
# MVP dialogue model: Option 2 — consumed-once.
# Each active quest contributes at most one dialogue line per NPC
# (Quest.dialogue_by_npc, keyed by Character.id). The first time the player
# clicks Talk with that NPC, get_pending_lines_for() returns the line; the
# popup shows it, then calls mark_delivered(quest_id, npc_id). Subsequent
# Talks fall back to the NPC's default greeting.
#
# FUTURE — Option 3: Stateful-by-trigger.
# Lines would be tied to quest events (quest_started, quest_progress_50,
# deadline_approaching, etc). Each event pushes a line onto a per-NPC queue;
# Talk drains the queue. Taxman could then say different things at quest
# start, half-paid, and one-day-out. Requires nested dict on Quest:
#   dialogue_by_npc_by_trigger: { npc_id: { trigger_key: line } }
# and a per-NPC line queue in QuestManager runtime state.
#endregion
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

const QUEST_BUNDLES_PATH := "res://scripts/quests/quest bundles/"

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

# All quests discovered by folder scan
var all_quests: Array[Quest] = []

func _ready() -> void:
	_scan_quest_folder(QUEST_BUNDLES_PATH)
	Logging.log_info("QuestManager: discovered %d quest(s)." % all_quests.size())
	GameController.inventory_changed.connect(_on_trade_complete)
	GameController.character_met.connect(_on_character_met)
	WorldClock.time_changed.connect(_on_time_changed)
	# Auto-start quests that should activate immediately
	for quest in all_quests:
		if quest.auto_start:
			activate_quest(quest)
	# Connect trigger_start_events for all quests that have one
	_connect_quest_triggers()

#region Quest Discovery

func _scan_quest_folder(path: String) -> void:
	var dir := DirAccess.open(path)
	if not dir:
		Logging.log_error("QuestManager: cannot open quest folder '%s'" % path)
		return
	dir.list_dir_begin()
	var entry := dir.get_next()
	while entry != "":
		var full_path := path.path_join(entry)
		if dir.current_is_dir():
			_scan_quest_folder(full_path)
		elif entry.ends_with(".tres"):
			var resource = load(full_path)
			if resource is Quest:
				all_quests.append(resource)
		entry = dir.get_next()

#endregion

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
		"delivered_dialogue": [],  # npc_ids who have heard this quest's line
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
	# Exact target match (NPC id, item id, etc.)
	if target != data.get("target_id", ""):
		return false
	# For GIVE/GET objectives, also constrain by item_id when specified.
	# Prevents e.g. giving Boots to the Taxman from counting toward a Coin tithe.
	if objective.item_id != "" and objective.item_id != data.get("item_id", ""):
		return false
	return true

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
	for quest in all_quests:
		if quest.trigger_start_event:
			quest.trigger_start_event.triggered.connect(
				func(event_data: Dictionary) -> void:
					if quest.id not in active_quests and quest.id not in completed_quests \
						and quest.id not in failed_quests:
						activate_quest(quest)
			)

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

#region Dialogue API

# Returns undelivered quest lines for this NPC across all active quests.
# Each entry: { "quest_id": String, "line": String }.
# Does NOT mutate state — caller must invoke mark_delivered() after each line
# is safely shown, so a crash mid-sequence doesn't silently consume lines.
func get_pending_lines_for(npc_id: String) -> Array[Dictionary]:
	var pending: Array[Dictionary] = []
	for quest_id in active_quests.keys():
		var quest_data = active_quests[quest_id]
		var quest: Quest = quest_data.resource
		if npc_id in quest_data.delivered_dialogue:
			continue
		if not quest.dialogue_by_npc.has(npc_id):
			continue
		pending.append({
			"quest_id": quest_id,
			"line": quest.dialogue_by_npc[npc_id],
		})
	return pending

# Marks a single quest line as delivered for (quest, npc). Called by the
# interaction popup after each line is shown to the player.
func mark_delivered(quest_id: String, npc_id: String) -> void:
	if not quest_id in active_quests:
		return
	var delivered: Array = active_quests[quest_id].delivered_dialogue
	if npc_id not in delivered:
		delivered.append(npc_id)

#endregion

func validate_quest_state() -> void:
	var issues := 0
	# Check that every quest with a trigger landed somewhere
	for quest in all_quests:
		if quest.trigger_start_event:
			var in_active = quest.id in active_quests
			var in_completed = quest.id in completed_quests
			var in_failed = quest.id in failed_quests
			if not in_active and not in_completed and not in_failed:
				Logging.log_warn("Quest '%s' has a trigger_start_event but hasn't activated." \
					% quest.id)
				issues += 1
	# Check for orphans — active quests not found in all_quests
	for quest_id in active_quests:
		var found := false
		for quest in all_quests:
			if quest.id == quest_id:
				found = true
				break
		if not found:
			Logging.log_warn("Quest '%s' is active but not in all_quests." % quest_id)
			issues += 1
	if issues == 0:
		Logging.log_info("Quest validation passed: %d active, %d completed, %d failed." \
			% [active_quests.size(), completed_quests.size(), failed_quests.size()])
	else:
		Logging.log_error("Quest validation found %d issue(s)." % issues)

#endregion
