extends Control

@export var music_player__shuffled_: AudioStreamPlayer
@export var button_play_pause: Button
@export var button_skip: Button
@export var track_title: Label
@export var panel: Panel
@export var v_box_container: VBoxContainer

@export_category("Scrubber")
@export var scrubber_current_playtime: Label
@export var scrubber_slide_playtime: HSlider
@export var scrubber_full_playtime: Label



var playlist: AudioStreamPlaylist
var current_index: int = 0
var shuffled_order: Array = []
var paused_position: float = 0.0

func _ready() -> void:
	playlist = music_player__shuffled_.stream as AudioStreamPlaylist
	_build_shuffled_order()
	music_player__shuffled_.finished.connect(_on_track_finished)
	_play_current()
	
	UI.ButtonMusicPlayerPressed.connect(_on_UI_Music_Player_button)
	
	# hidden by default
	if panel.visible and v_box_container.visible:
		panel.hide()
		v_box_container.hide()

func _build_shuffled_order() -> void:
	shuffled_order = range(playlist.stream_count)
	shuffled_order.shuffle()

func _play_current() -> void:
	var real_index = shuffled_order[current_index]
	music_player__shuffled_.stream = playlist.get_list_stream(real_index)
	music_player__shuffled_.play()
	track_title.text = "Playing: " + "\n" + music_player__shuffled_.stream.resource_path.get_file().get_basename()
	var full_track_length = music_player__shuffled_.stream.get_length()
	scrubber_slide_playtime.max_value = full_track_length
	scrubber_full_playtime.text = _format_time(full_track_length)

func _process(delta: float) -> void:
	button_play_pause.text = "▶"
	if music_player__shuffled_.playing:
		button_play_pause.text = "⏸"
		scrubber_slide_playtime.value = music_player__shuffled_.get_playback_position()
		scrubber_current_playtime.text = _format_time(music_player__shuffled_.get_playback_position())

func _on_track_finished() -> void:
	print("signal! _on_track_finished")
	current_index = (current_index + 1) % shuffled_order.size()
	# Reshuffle when we've cycled through everything
	if current_index == 0:
		_build_shuffled_order()
		print("_on_track_finished: built shuffled order, index was 0")
	_play_current()

func _on_button_play_pause_button_down() -> void:
	if music_player__shuffled_.playing:
		paused_position = music_player__shuffled_.get_playback_position()
		music_player__shuffled_.stop()
		return
	music_player__shuffled_.play()
	if paused_position > 0:
		music_player__shuffled_.seek(paused_position)

func _on_button_skip_button_down() -> void:
	paused_position = 0.0
	current_index = (current_index + 1) % shuffled_order.size()
	if current_index == 0:
		_build_shuffled_order()
	_play_current()

func toggle() -> void:
	var show = !panel.visible
	panel.visible = show
	v_box_container.visible = show

func _format_time(seconds: float) -> String:
	var mins := int(seconds) / 60
	var secs := int(seconds) % 60
	return "%d:%02d" % [mins, secs]

func _on_UI_Music_Player_button():
	toggle()
