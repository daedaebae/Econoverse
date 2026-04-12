extends Control

@export var button_resume: Button
@export var sfx_select: AudioStreamPlayer

func _process(delta: float) -> void:
	if get_tree().paused:
		show()

func _on_button_resume_button_down() -> void:
	get_tree().paused = false
	self.hide()

func _unhandled_input(event: InputEvent) -> void:
	# on escape, check the state of pause and swap it
	if event.is_action_pressed("pause"): #escape key
		get_tree().paused = !get_tree().paused
		#also match this scene's visibility based on state
		visible = get_tree().paused

func _pause_sound() -> void:
		sfx_select.pitch_scale = 3 if get_tree().paused else 4.5
		sfx_select.play()


func _on_visibility_changed() -> void:
	if not is_inside_tree():
		return
	_pause_sound()
