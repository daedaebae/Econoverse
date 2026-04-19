extends Resource
class_name EventResource

@export var id : String = "event_key" # unique key for listeners to match against

signal triggered(event_data: Dictionary)

func fire(data: Dictionary = {}) -> void:
	data["event_id"] = id
	triggered.emit(data)
