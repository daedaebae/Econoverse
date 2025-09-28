extends Control

@onready var gemma = $PanelContainer/VBoxContainer/RichTextLabel
@onready var textEdit = $PanelContainer/VBoxContainer/TextEdit
@onready var chat = $Blacksmith

func sendtext():
	textEdit.editable = false
	chat.say(textEdit.text)

func _input(event: InputEvent) -> void:
	if (event.is_action("ui_text_newline")):
		sendtext()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_nobody_who_chat_response_updated(new_token: String) -> void:
	gemma.text += new_token
	pass # Replace with function body.


func _on_nobody_who_chat_response_finished(response: String) -> void:
	textEdit.editable = true
	textEdit.text = ""
	pass # Replace with function body.
