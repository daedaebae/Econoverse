extends VBoxContainer

# Pinned quest tracker — right side of screen, notifications layer.
# Displays up to three active quests. Each cluster shows a quest's title
# and its first objective's progress. Clusters start hidden and populate
# as quests activate; they hide again on completion or failure.
#
# FUTURE:
# - Player-selected pinning (currently auto-pins first 3 activations)
# - Multi-objective quests: cycle objectives or show all
# - Subtle alpha/color animations on add / progress tick / complete

@export var cluster_quest_1: VBoxContainer
@export var cluster_quest_2: VBoxContainer
@export var cluster_quest_3: VBoxContainer

# quest_id -> cluster VBoxContainer currently displaying it
var tracked: Dictionary = {}

# Intro tween tuning. All tracks ride on `modulate` — VBoxContainer has no
# visuals of its own, so `self_modulate` is invisible here. `modulate` tints
# the container AND its children (the labels), which is what we want.
const INTRO_FADE_DURATION		:= 0.8   # seconds for alpha 0 → 1
const SHIMMER_PULSE_COUNT		:= 5     # number of bright-dim cycles
const SHIMMER_HALF_CYCLE		:= 0.04   # seconds per half-cycle (up or down)
const SHIMMER_SETTLE_DURATION	:= 0.9   # ease back to default after shimmering
const SHIMMER_COLOR				:= Color(1.0, 0.867, 0.0, 1.0)  # flash tint
const DEFAULT_COLOR				:= Color(1.0, 1.0, 1.0, 1.0)

# Outro tween tuning. Slow pulsing while alpha fades to 0 — a calm
# "assurement" note as the quest wraps up. Completion uses a reassuring
# green; failure uses a muted brick red so the tone differs without
# becoming alarming.
const OUTRO_PULSE_COUNT			:= 4      # bright/dim cycles over the fade
const OUTRO_HALF_CYCLE			:= 0.45   # slow pulse — seconds per half
const OUTRO_COLOR_WIN			:= Color(0.35, 1.0, 0.45, 1.0)  # reassuring green
const OUTRO_COLOR_LOSE			:= Color(0.65, 0.25, 0.22, 1.0)  # brick red, not aggressive

func _ready() -> void:
	# Hide all clusters at start; they reveal as quests activate.
	for cluster in _all_clusters():
		cluster.visible = false
	QuestManager.quest_started.connect(_on_quest_started)
	QuestManager.quest_progress.connect(_on_quest_progress)
	QuestManager.quest_completed.connect(_on_quest_completed)
	QuestManager.quest_failed.connect(_on_quest_failed)

func _all_clusters() -> Array:
	return [cluster_quest_1, cluster_quest_2, cluster_quest_3]

# Finds the first hidden cluster for a new quest. Returns null if all three
# slots are full — in that case the quest is simply not tracked on the HUD.
func _find_free_cluster() -> VBoxContainer:
	for cluster in _all_clusters():
		if not cluster.visible:
			return cluster
	return null

func _on_quest_started(quest_id: String) -> void:
	if quest_id in tracked:
		return
	var cluster := _find_free_cluster()
	if cluster == null:
		Logging.log_warn("QuestTracker: no free slot for quest '%s'." % quest_id)
		return
	var quest: Quest = QuestManager.active_quests[quest_id].resource
	cluster.label_quest_name.text = quest.title
	cluster.label_quest_objective.text = _format_objective_text(quest_id)
	_play_intro_tween(cluster)
	tracked[quest_id] = cluster

func _on_quest_progress(quest_id: String, _objective_id: String, _current: int, _required: int) -> void:
	if quest_id not in tracked:
		return
	var cluster: VBoxContainer = tracked[quest_id]
	cluster.label_quest_objective.text = _format_objective_text(quest_id)

func _on_quest_completed(quest_id: String) -> void:
	_end(quest_id, true)

func _on_quest_failed(quest_id: String) -> void:
	_end(quest_id, false)

# Shared end path. `completion` selects the outro color; all other teardown
# is identical between win and lose.
func _end(quest_id: String, completion: bool) -> void:
	if quest_id not in tracked:
		return
	var cluster: VBoxContainer = tracked[quest_id]
	# Free the tracking slot immediately so new quests don't have to wait on
	# the outro tween. Cluster stays .visible=true until the tween completes,
	# so _find_free_cluster() still won't hand this slot out mid-animation.
	tracked.erase(quest_id)
	_play_outro_tween(cluster, completion)

# Energize-into-existence tween. Sequential phases on `modulate`:
#   1. Alpha fade: modulate.a 0 → 1. RGB stays white, text materializes
#      in its normal color.
#   2. Shimmer pulses: modulate tweens white → SHIMMER_COLOR → white, repeated.
#      Every keyframe keeps alpha at 1 so the cluster never flickers
#      transparent during a pulse.
#   3. Settle: final ease back to default white for a soft landing.
# We tween modulate (not self_modulate) because VBoxContainer has no own
# visuals — self_modulate would tint nothing. modulate tints descendants.
func _play_intro_tween(cluster: VBoxContainer) -> void:
	cluster.modulate = Color(1.0, 1.0, 1.0, 0.0)
	cluster.visible = true
	var tween := create_tween()
	# Phase 1 — alpha fade-in.
	tween.tween_property(cluster, "modulate:a", 1.0, INTRO_FADE_DURATION) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_SINE)
	# Phase 2 — shimmer. Alpha component of each target stays at 1.
	for i in SHIMMER_PULSE_COUNT:
		tween.tween_property(cluster, "modulate", SHIMMER_COLOR, SHIMMER_HALF_CYCLE)
		tween.tween_property(cluster, "modulate", DEFAULT_COLOR, SHIMMER_HALF_CYCLE)
	# Phase 3 — settle.
	tween.tween_property(cluster, "modulate", DEFAULT_COLOR, SHIMMER_SETTLE_DURATION) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_SINE)

# Quest-ending tween. Pulses OUTRO_COLOR ↔ white while alpha slides toward 0,
# so the cluster "assures" itself out of view instead of simply disappearing.
# Alpha is baked into each pulse keyframe (rather than running as a parallel
# track) so we don't fight ourselves on the shared `modulate` property.
# At the final keyframe alpha = 0; we then hide and reset for reuse.
func _play_outro_tween(cluster: VBoxContainer, completion: bool) -> void:
	var pulse_color: Color = OUTRO_COLOR_WIN if completion else OUTRO_COLOR_LOSE
	var tween := create_tween()
	for i in OUTRO_PULSE_COUNT:
		var alpha_on_bright	: float = 1.0 - float(i) / OUTRO_PULSE_COUNT
		var alpha_on_dim	: float = 1.0 - float(i + 1) / OUTRO_PULSE_COUNT
		var bright			:= Color(pulse_color.r, pulse_color.g, pulse_color.b, alpha_on_bright)
		var dim				:= Color(DEFAULT_COLOR.r, DEFAULT_COLOR.g, DEFAULT_COLOR.b, alpha_on_dim)
		tween.tween_property(cluster, "modulate", bright, OUTRO_HALF_CYCLE)
		tween.tween_property(cluster, "modulate", dim, OUTRO_HALF_CYCLE)
	# When the tween finishes, cluster modulate is already (1,1,1,0) — hide
	# and reset modulate so the slot is clean for its next quest.
	tween.tween_callback(func() -> void:
		cluster.visible = false
		cluster.modulate = DEFAULT_COLOR
	)

# Builds the objective line: "{description} ({current} / {required})".
# MVP assumes one primary objective per quest; shows the first one.
func _format_objective_text(quest_id: String) -> String:
	var quest_data = QuestManager.active_quests[quest_id]
	var quest: Quest = quest_data.resource
	if quest.objectives.is_empty():
		return ""
	var obj: QuestObjective = quest.objectives[0]
	var current: int = quest_data.objectives_progress[obj.id]
	return "%s (%d / %d)" % [obj.description, current, obj.required_quantity]
