extends Control

# The first layer of NPC interaction. Appears anchored to the NPC on click,
# shows their name and greeting, and offers Talk or Trade.
#
# Future considerations:
# - Talk opens a larger DialoguePanel with conversation options (Rumors,
#   event-driven topics, quest-specific dialogue)
# - Enlarged NPC sprite with idle/reaction animations in the dialogue panel
# - Background dim/wash when in dialogue
# - NPC-initiated conversations (NPC walks to player and triggers this)
# - Conversation options that appear/disappear based on events_to_handle

@export var panel: PanelContainer
@export var label_name: Label
@export var label_greeting: Label
@export var button_talk: Button
@export var button_trade: Button
@export var button_leave: Button

var current_npc: Node = null

# Dialogue walk state. When pending_lines is non-empty, the player is mid-walk:
# Talk button label swaps to "Continue", Trade/Leave are locked, and clicks
# outside the panel are ignored until the walk completes.
var pending_lines: Array[Dictionary] = []
var line_index: int = 0

func _ready() -> void:
	visible = false
	GameController.register_interaction_popup(self)
	button_talk.pressed.connect(_on_talk_pressed)
	button_trade.pressed.connect(_on_trade_pressed)
	button_leave.pressed.connect(close)

func _is_walking() -> bool:
	return not pending_lines.is_empty()

func show_for_npc(npc: Character) -> void:
	current_npc = npc
	# Display name, or ??? if the player hasn't met this character yet
	if npc.met:
		label_name.text = npc.char_name
	else:
		label_name.text = "???"
	label_greeting.text = npc.get_greeting()
	# Trade is locked until the player has talked to this NPC
	button_trade.disabled = not npc.met
	# Position the panel on the right side of the screen, centered vertically
	var vp_size := get_viewport_rect().size
	panel.position.x = vp_size.x - panel.size.x - 36
	panel.position.y = (vp_size.y - panel.size.y) / 2
	# Fade in
	panel.modulate.a = 0.0
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = true
	var tween := create_tween()
	tween.tween_property(panel, "modulate:a", 1.0, 0.6)
	GameController.set_player_interacting(true)
	GameController.player_node.focus_on_npc(npc)

func close() -> void:
	# Don't let the player escape mid-dialogue. Trade/Leave and outside-clicks
	# all route through here; guarding once covers all paths.
	if _is_walking():
		return
	current_npc = null
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	GameController.set_player_interacting(false)
	GameController.player_node.unfocus()
	var tween := create_tween()
	tween.tween_property(panel, "modulate:a", 0.0, 0.4)
	tween.tween_callback(func(): visible = false)

func _on_talk_pressed() -> void:
	if not current_npc:
		return
	# Advancing through an in-progress dialogue walk
	if _is_walking():
		_advance_walk()
		return
	# Mark as met on first interaction. on_character_met may fire
	# on_first_talk_event, which could activate a quest that contributes a
	# dialogue line — so this must run before we query on_talk().
	if not current_npc.met:
		current_npc.met = true
		GameController.on_character_met(GameController.player_node, current_npc)
		label_name.text = current_npc.char_name
		button_trade.disabled = false
	# Query pending quest dialogue. Empty = no quest lines; existing greeting
	# stays in LabelGreeting and the player can still Trade/Leave.
	pending_lines = current_npc.on_talk()
	if pending_lines.is_empty():
		Logging.log_info("Talk: %s — no pending quest dialogue." % current_npc.char_name)
		return
	# Begin walk: lock Trade/Leave, swap Talk → Continue, show first line.
	line_index = 0
	button_talk.text = "Continue"
	button_trade.disabled = true
	button_leave.disabled = true
	label_greeting.text = pending_lines[0].line

func _advance_walk() -> void:
	# Mark the line just shown as delivered, then move to the next one or finish.
	var current_entry: Dictionary = pending_lines[line_index]
	QuestManager.mark_delivered(current_entry.quest_id, current_npc.id)
	line_index += 1
	if line_index >= pending_lines.size():
		_end_walk()
		return
	label_greeting.text = pending_lines[line_index].line

func _end_walk() -> void:
	pending_lines = []
	line_index = 0
	button_talk.text = "Talk"
	button_trade.disabled = false
	button_leave.disabled = false
	label_greeting.text = current_npc.get_greeting()

func _on_trade_pressed() -> void:
	if not current_npc:
		return
	var npc = current_npc
	close()
	# Hand off to GameController's trade flow
	GameController.open_trade_with(npc)

func _gui_input(event: InputEvent) -> void:
	# Click on the root Control (outside the panel) closes the popup
	if event is InputEventMouseButton and event.is_pressed():
		close()
