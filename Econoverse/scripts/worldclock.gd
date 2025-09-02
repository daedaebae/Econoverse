# TODO: move worldclock.gd off of main node and call it from main.gd

extends Control

var meridian = 'am'
var clock_hours = 5
var clock_mins = 0
var day = 1
# TODO: used in call_dialogue function
var dialogue = preload("res://scripts/dialogue.gd")
var resource = load("res://assets/dialogue/intro.dialogue")
var states = ["start", "stop"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: move all this to call_dialogue function
	var dialogue_line = await DialogueManager.get_next_dialogue_line(resource, 
	"start")
	dialogue_line = await DialogueManager.get_next_dialogue_line(resource, 
	dialogue_line.next_id)
	DialogueManager.show_dialogue_balloon_scene(
		"res://scenes/Balloon.tscn", resource, "start"
	)
	#dialogue.call_dialogue()
	pass

func on_timer_timeout():
	clock_mins += 1
	
	# am/pm checks, day counter
	if clock_hours == 12 && clock_mins == 60 && meridian == 'am':
			meridian = 'pm'
	elif clock_hours == 12 && clock_mins == 60 && meridian == 'pm':
			meridian = 'am'
			day += 1
	
	# handle minute -> hour rollover
	if clock_mins == 60:
		clock_mins = 0
		clock_hours += 1
	
	# standard time instead of mil-time
	if clock_hours == 13:
		clock_hours = 1
	
	# set Day and Time label to regexed vars
	$TimeModule/WorldClock.text = 'Day %d   %02d:%02d%s' % [day, clock_hours, clock_mins, meridian]

# TODO: Tie to a button that sets game speed to normal, fast, or turbo
# TODO: Move function to Game Controls module?
func game_speed(speed):
	match speed:
		0:
			$TimeModule/Timer.wait_time = 1
		1:
			$TimeModule/Timer.wait_time = 0.75
		2:
			$TimeModule/Timer.wait_time = 0.25

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
