extends Node

signal time_changed(day: int, hour: int, minute: int)

# How many real seconds = 1 in-game minute                                                                                                                                                                                                             
@export var seconds_per_game_minute: float = 1.0

var day: int = 1
var hour: int = 6       # start at 6am                                                                                                                                                                                                                 
var minute: int = 0
var _accumulator: float = 0.0
var _paused: bool = false                                                                                                                                                                                                                              

#region Lifecycle                                                                                                                                                                                                                                      

func _ready() -> void:                                                                                                                                                                                                                                 
	GameController.register_clock(self)

func _process(delta: float) -> void:
	if _paused:
		return
		_accumulator += delta                                                                                                                                                                                                                              
	if _accumulator >= seconds_per_game_minute:
		_accumulator -= seconds_per_game_minute                                                                                                                                                                                                        
	_tick() 

#endregion Lifecycle                                                                                                                                                                                                                                   

#region Clock Logic                                                                                                                                                                                                                                    

func _tick() -> void:
	minute += 1
	if minute >= 60:
		minute = 0
		hour += 1
	if hour >= 24:
		hour = 0                                                                                                                                                                                                                                       
		day += 1
	emit_signal("time_changed", day, hour, minute)                                                                                                                                                                                                     
	Logging.set_game_time(day, float(hour) + minute / 60.0)
#endregion Clock Logic

#region Public API
func pause_clock() -> void:
	_paused = true

func resume_clock() -> void:
	_paused = false

func get_time_string() -> String:
	var meridian := "am" if hour < 12 else "pm"                                                                                                                                                                                                        
	var display_hour := hour if hour <= 12 else hour - 12                                                                                                                                                                                              
	if display_hour == 0:                                                                                                                                                                                                                              
		display_hour = 12                                                                                                                                                                                                                              
	return "Day %d  %02d:%02d%s" % [day, display_hour, minute, meridian]

#endregion Public API
