extends Node

#var counter = 0
var total_time_in_secs : int = 0
var day = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$TimeModule/Timer.start()
	pass

func on_timer_timeout():
	total_time_in_secs += 1
	var m = int(total_time_in_secs / 60.0)
	var s = total_time_in_secs - m * 60
	$TimeModule/WorldClock.text = '%02d:%02d' % [m, s]
	
	#every cyce of 60 =  1 day game time
	if m == 60:
		$TimeModule/Days.text = "Days"+str(day)
		total_time_in_secs = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
