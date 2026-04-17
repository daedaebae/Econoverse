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

func _ready() -> void:
	visible = false
	GameController.register_interaction_popup(self)
	button_talk.pressed.connect(_on_talk_pressed)
	button_trade.pressed.connect(_on_trade_pressed)
	button_leave.pressed.connect(close)

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
	# Position the panel on the NPC's screen position, clamped to viewport
	var screen_pos := npc.get_global_transform_with_canvas().origin
	var vp_size := get_viewport_rect().size
	var margin := 20.0
	screen_pos.x = clampf(screen_pos.x, margin, vp_size.x - panel.size.x - margin)
	screen_pos.y = clampf(screen_pos.y, margin, vp_size.y - panel.size.y - margin)
	panel.position = screen_pos
	# Catch clicks outside the panel to close
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = true
	GameController.set_player_interacting(true)

func close() -> void:
	current_npc = null
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	GameController.set_player_interacting(false)

func _on_talk_pressed() -> void:
	if not current_npc:
		return
	# Mark as met on first interaction
	if not current_npc.met:
		current_npc.met = true
		GameController.on_character_met(GameController.player_node, current_npc)
		# Update name and unlock trade now that they've met
		label_name.text = current_npc.char_name
		button_trade.disabled = false
	# TODO: Open DialoguePanel with conversation options (Rumors, event topics, etc.)
	Logging.log_info("Talk: %s — (dialogue panel not yet implemented)" % current_npc.char_name)

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
