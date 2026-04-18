extends Control

# Intentional two-part quest-start announcement, free-floating typography
# (no panel background). Pacing is deliberately slow — "Quest Started"
# appears first and dwells briefly on its own, then the quest title joins
# beneath it. Both settle together, then fade together.
#
# Inspired by the Skyrim stinger pattern (label above, title below) but
# slowed down to feel substantial rather than punctuation-quick. Text
# relies on shadow + contrast rather than a parchment panel, so the world
# behind stays readable.
#
# Pairs with the tracker cluster: toast announces the moment and fades;
# tracker holds the ongoing objective afterwards.
#
# FUTURE:
# - Audio: a soft sting on prefix reveal, a warmer note on title reveal
# - Skippable via input for replaying players
# - Subtle upward drift on title fade-in to add motion without distraction

@export var panel: Control
@export var label_prefix: Label
@export var label_title: Label

# Timing — calibrated slow-and-intentional. Total ~5.6s from trigger to gone.
const PREFIX_FADE_DURATION	:= 1.0   # "Quest Started" eases in
const PREFIX_SOLO_HOLD		:= 0.6   # beat of the prefix alone
const TITLE_FADE_DURATION	:= 1.0   # title joins underneath
const BOTH_HOLD_DURATION	:= 2.0   # both dwell together
const FADE_OUT_DURATION		:= 1.0   # both exit together

const PREFIX_TEXT := "Quest Started"

var _active_tween: Tween = null
# FIFO of quest_ids waiting to announce. If several quests start in the same
# frame (e.g. a chained trigger), each gets its full ceremony in turn rather
# than clobbering each other.
var _queue: Array[String] = []
var _is_playing: bool = false

func _ready() -> void:
	visible = false
	label_prefix.modulate.a = 0.0
	label_title.modulate.a = 0.0
	QuestManager.quest_started.connect(_on_quest_started)

func _on_quest_started(quest_id: String) -> void:
	if quest_id not in QuestManager.active_quests:
		return
	_queue.append(quest_id)
	if not _is_playing:
		_play_next()

func _play_next() -> void:
	if _queue.is_empty():
		_is_playing = false
		visible = false
		return
	var quest_id: String = _queue.pop_front()
	# Quest may have been resolved between enqueue and play — skip gracefully.
	if quest_id not in QuestManager.active_quests:
		_play_next()
		return
	var quest: Quest = QuestManager.active_quests[quest_id].resource
	label_prefix.text = PREFIX_TEXT
	label_title.text = quest.title
	_play_toast()

func _play_toast() -> void:
	_is_playing = true
	if _active_tween and _active_tween.is_valid():
		_active_tween.kill()
	label_prefix.modulate.a = 0.0
	label_title.modulate.a = 0.0
	visible = true
	_active_tween = create_tween()
	# 1 — prefix fades in alone
	_active_tween.tween_property(label_prefix, "modulate:a", 1.0, PREFIX_FADE_DURATION) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	# 2 — prefix holds solo, building anticipation for the title
	_active_tween.tween_interval(PREFIX_SOLO_HOLD)
	# 3 — title joins beneath
	_active_tween.tween_property(label_title, "modulate:a", 1.0, TITLE_FADE_DURATION) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	# 4 — both hold together
	_active_tween.tween_interval(BOTH_HOLD_DURATION)
	# 5 — exit: both fade in parallel. parallel() makes the next step run
	# alongside the previous one (the prefix fade-out).
	_active_tween.tween_property(label_prefix, "modulate:a", 0.0, FADE_OUT_DURATION) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	_active_tween.parallel().tween_property(label_title, "modulate:a", 0.0, FADE_OUT_DURATION) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	_active_tween.tween_callback(_play_next)
