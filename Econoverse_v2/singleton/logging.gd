extends Logger

class_name Logs

var file: FileAccess

func _init():
	file = FileAccess.open("res://game.log", FileAccess.WRITE)
	_log("Logger initialized")

func _exit():
	_log("Logger shutdown")
	if file:
		file.close()

func _log(message: String):
	var timestamp = Time.get_time_string_from_system() + " | "
	var log_entry = timestamp + message
	print(log_entry)  # Output to console
	if file:
		file.store_line(log_entry)
		file.flush()  # Ensure immediate write

func info(message: String):
	_log("INFO: " + message)

func warn(message: String):
	_log("WARN: " + message)

func error(message: String):
	_log("ERROR: " + message)

# Global logger instance (add this script as Autoload)
var log = Logger.new()   
