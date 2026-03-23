extends Node

class_name GameLogger

signal log_written(entry: String)
signal toggle_log_window

const log_file = "res://game.log"
#TODO: durf - switch these to make persistent, res: just for session based logging.
#const log_file = "user://game.log"

var file: FileAccess
var game_day: int = 1
var game_hour: float = 0.0

func _ready() -> void:
	_open_log_file()
	GameController.register_logger(self)
	log_info("=== SESSION START ===")

func _exit_tree() -> void:
	log_info("=== SESSION END ===")
	if file:
		file.close()

#region File Setup

func _open_log_file() -> void:
	if FileAccess.file_exists(log_file):
		file = FileAccess.open(log_file, FileAccess.READ_WRITE)
		if file:
			file.seek_end()
	else:
		file = FileAccess.open(log_file, FileAccess.WRITE)
	if not file:
		push_error("Logger: Failed to open log file at " + log_file)

#endregion File Setup

#region Internal fuctions

func _timestamp() -> String:
	var real := Time.get_datetime_string_from_system()
	var game := "Day %d  %02d:00" % [game_day, int(game_hour)]
	return "[%s | GameTime: %s]" % [real, game]

func _write(level: String, message: String) -> void:
	var entry := "%s [%s] %s" % [_timestamp(), level, message]
	match level:
		"ERROR": push_error(entry)
		"WARN":  push_warning(entry)
		_:       print(entry)
	emit_signal("log_written", entry)
	if file:
		file.store_line(entry)
		file.flush()

#endregion Internal functions

#HACK: durf - Use these functions when you need to log something!
func log_info(message: String) -> void:
	_write("INFO", message)

func log_warn(message: String) -> void:
	_write("WARN", message)

func log_error(message: String) -> void:
	_write("ERROR", message)

func set_game_time(day: int, hour: float) -> void:
	game_day = day
	game_hour = hour

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_log"):
		emit_signal("toggle_log_window")
