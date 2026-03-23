# --- ui_log_window.gd ---
# Populates with existing game.log contents on start,
# then appends new entries live via the Logging signal.

extends Window

@onready var output: RichTextLabel = %LogOutput

func _ready() -> void:
	#_set_window_size()
	hide()
	_load_existing_logs()
	Logging.log_written.connect(_on_log_written)
	Logging.toggle_log_window.connect(func(): visible = !visible)
	close_requested.connect(hide)

#func _set_window_size() -> void:
	#var win := DisplayServer.window_get_size()
	#var h := int(win.y * 0.2)
	#size = Vector2i(win.x, h)
	#position = Vector2i(0, win.y - h)

func _load_existing_logs() -> void:
	if not FileAccess.file_exists(Logging.log_file):
		return
	var f := FileAccess.open(Logging.log_file, FileAccess.READ)
	if not f:
		return
	while not f.eof_reached():
		var line := f.get_line()
		if line != "":
			output.append_text(line + "\n")
	f.close()

func _on_log_written(entry: String) -> void:
	output.append_text(entry + "\n")
