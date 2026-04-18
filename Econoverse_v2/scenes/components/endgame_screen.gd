extends Control

# Minimal endgame screen. Listens for GAME_WIN / GAME_LOSE EventResources and
# shows a final verdict message with an Exit button. Intentionally does NOT
# pause the tree — the world freezes naturally once the quest resolves, and
# we want the background to stay alive for whatever tiny closing ambience
# remains. This is a stop-gap; a richer endgame summary comes later.

@export var label: Label
@export var button_exit: Button
@export var sfx_select: AudioStreamPlayer

@export var win_event: EventResource
@export var lose_event: EventResource

@export var win_message: String = "The tithe is paid."
@export var lose_message: String = "The Realm collects its due."

func _ready() -> void:
	hide()
	if win_event:
		win_event.triggered.connect(_on_win)
	if lose_event:
		lose_event.triggered.connect(_on_lose)

func _on_win(_data: Dictionary) -> void:
	_show_with(win_message)

func _on_lose(_data: Dictionary) -> void:
	_show_with(lose_message)

func _show_with(text: String) -> void:
	label.text = text
	show()

func _on_button_exit_button_down() -> void:
	if sfx_select:
		sfx_select.play()
	get_tree().quit()
