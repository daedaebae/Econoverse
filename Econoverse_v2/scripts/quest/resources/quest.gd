extends Resource
class_name Quest

@export var id			:	String 	= "quest_ReplaceThis_01"
	# unique key, never changes
@export var title		:	String 	= "Replace This"
	# Display name for the quest log
@export_multiline() var description:String 	= "This is about, hey replace this description"
	# First-person journal prose
	
enum quest_type {TUTORIAL, MAIN_STORY, SURPRISE, TYPICAL} 
	# tutorial:   Teaches a mechanic through a character's need. Gentle, no harsh failure.
	# main_story: Core narrative quests. High stakes, win/lose conditions.
	# surprise:   Unexpected events from world state. Breaks routine. 
	# typical:    Standard side quests
@export var _type		:	quest_type	= quest_type.TYPICAL 
	# Design-facing classification, not gameplay data.
	# Informs how the UI treats the quest (toasts, pinning) and how failure should feel.

@export var objectives		: Array[QuestObjective]
@export var days_to_complete : int	= 2

@export var completion_event	: EventResource
@export var failure_event		: EventResource
