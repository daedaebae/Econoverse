extends Control

@export var music_player__shuffled_: AudioStreamPlayer
@export var button_play_pause: Button
@export var button_skip: Button
@export var track_title: Label

var playlist: AudioStreamPlaylist
var current_index: int
var current_stream: AudioStream

func _ready() -> void:
	
	playlist = music_player__shuffled_.stream as AudioStreamPlaylist
	current_index = 0
	current_stream = playlist.get_list_stream(current_index)
	
	# good place to check on player options and add boolean condition
	if music_player__shuffled_: 
		music_player__shuffled_.play()

func _process(delta: float) -> void:
	#continually update the playlist index so other functions can refer to it
	current_index = music_player__shuffled_.get_playback_position()
	current_stream = playlist.get_list_stream(current_index)
	
	button_play_pause.text = "▶"
	if music_player__shuffled_.playing:
		button_play_pause.text = "⏸"
		
		# update the displayed track name
		var playing_track = null
		if playlist:
			if track_title.text != current_stream.resource_path.get_file():
				playing_track = track_title.text
				#TODO kc - work in music track text fade tween for polish
				track_title.text = current_stream.resource_path.get_file()


func _on_button_play_pause_button_down() -> void:
	if music_player__shuffled_.playing:
		music_player__shuffled_.stop()
		return
	music_player__shuffled_.play()


func _on_button_skip_button_down() -> void:
	current_index = (current_index + 1) % playlist.stream_count
	music_player__shuffled_.stop()
	music_player__shuffled_.play()
