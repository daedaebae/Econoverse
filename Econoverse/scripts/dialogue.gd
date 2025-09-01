class_name Dialogue
extends Control

# We are going to use this logic to test, will be removed later
func call_dialogue():
	var resource = load("res://assets/dialogue/intro.dialogue")
# then
	var dialogue_line = await DialogueManager.get_next_dialogue_line(resource, "start")
	return
