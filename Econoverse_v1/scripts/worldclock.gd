# TODO: move worldclock.gd off of main node and call it from main.gd

extends Control

var meridian = 'am'
var clock_hours = 5
var clock_mins = 0
var day = 1

# Used in call_dialogue function
var dialogue = preload("res://scripts/dialogue.gd")
var currency = preload("res://scripts/currency_mgmt.gd")
var resource = load("res://assets/dialogue/intro.dialogue")
#TODO: Is states needed?
var states = ["start", "stop"]
@export var TopLayer: CanvasLayer
@export var menu_paused: Control
@export var menu_options: Control
@export var world_map: Control
@export var commodities_menu: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#region Dialogue Kickoff
	# TODO: move all this to call_dialogue function
	var dialogue_line = await DialogueManager.get_next_dialogue_line(resource, 
	"start")
	dialogue_line = await DialogueManager.get_next_dialogue_line(resource, 
	dialogue_line.next_id)
	DialogueManager.show_dialogue_balloon_scene(
		"res://scenes/Balloon.tscn", resource, "start"
	)
	#dialogue.call_dialogue()
	#endregion Dialogue Kickoff
	

func _input(event):
	# kc 9/6/2025 moved all visibility scripts here to elevate and 
	# ensure canvas layer is hidden if game isn't paused. 
	# Additionally, these operators need to compare each other since they share 
	# the same canvas layer and Z Index. Could solve this later, but quick and 
	# easy to do this way.
	#TODO kc 9/6/25 tween fade-in and out alpha for menus.
	#TODO kc 9/6/25 designate textures or shader for menu consistency. Could set modulate funcs locally to scenes for variety. 
	#region TopLayer Menus
		# kc 9/6 added to ensure canvas layer is hidden if game isn't paused.
	if get_tree().paused == false:
		TopLayer.hide() 
		
	if Input.is_action_just_pressed("exit"):
		# Enable TopLayer and pause if not already TopLayer
		if !TopLayer.visible:
			TopLayer.show()
			menu_paused.show()
			get_tree().paused = true
		# Close pause menu if visible
		elif menu_paused.visible:
			menu_paused.hide()
			TopLayer.hide()
			get_tree().paused = false
		# Close world map if visible
		elif world_map.visible:
			print("Map closed - exit key pressed")
			world_map.hide()
			TopLayer.hide()
			get_tree().paused = false
		# Close commod menu if visible
		elif commodities_menu.visible:
			print("Commodities closed - exit key pressed")
			commodities_menu.hide()
			TopLayer.hide()
			get_tree().paused = false
		# Go back to pause menu if options menu visible
		elif menu_options.visible:
			menu_options.hide()
			menu_paused.show()
		else:
			TopLayer.show()
			menu_paused.show()
			get_tree().paused = true
			
	if Input.is_action_just_pressed("Map"):
		if menu_paused.visible or menu_options.visible:
			print("Map not shown - options or paused visible")
			return
		elif !TopLayer.visible:
			TopLayer.show()
			world_map.show()
			get_tree().paused = true
		elif world_map.visible:
			world_map.hide()
			TopLayer.hide()
			get_tree().paused = false
			
	if Input.is_action_just_pressed("commods"):
		if menu_paused.visible or menu_options.visible:
			print("Map not shown - options or paused visible")
			return
		elif !TopLayer.visible:
			TopLayer.show()
			commodities_menu.show()
			get_tree().paused = true
		elif commodities_menu.visible:
			commodities_menu.hide()
			TopLayer.hide()
			get_tree().paused = false
	#endregion
	
#region WorldClock
#kc 9/13/25; The WorldClock system should be it's own independent scene for future implementations. 
# This way, the scene and clock variables can independently work regardless of any other program logic. 
# Game controllers can control, update, and assign values externally if needed.

#kc 9/13/25; store the labels individually, so we can quickly implement a time-based system.
@export var LabelDay: Label
@export var LabelHours: Label
@export var LabelMins: Label
@export var LabelMeridian: Label
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
	#kc 9/13/25; broke out individual values to improve UI seating, future use case improvements.
	LabelDay.text = 'Day %d' % [day] 
	LabelHours.text = '%02d' % [clock_hours]
	LabelMins.text = '%02d' % [clock_mins]
	LabelMeridian.text = '%s' % [meridian]

# TODO: Tie to a button that sets game speed to normal, fast, or turbo (v2.0)
# TODO: Move function to Game Controls module (v2.0)
func game_speed(speed):
	match speed:
		0:
			$TimeModule/Timer.wait_time = 1
		1:
			$TimeModule/Timer.wait_time = 0.75
		2:
			$TimeModule/Timer.wait_time = 0.25
#endregion

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
