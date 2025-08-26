extends Node
@onready var world_clock: Label = $TimeModule/WorldClock

var counter = 0
var eventtimer = Timer.new()
var time = str(Time.get_time_string_from_system())

# Event time to trigger events
func _on_timer_timeout():
	eventtimer.stop()
	eventtimer.timeout
	print("Oh shit what now?!?")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	eventtimer.start()
	counter += 1
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	world_clock.text = str(Time.get_ticks_msec()/1000)
	pass
