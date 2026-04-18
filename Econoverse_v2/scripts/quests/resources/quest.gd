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
@export var auto_start		: bool	= false
	# If true, QuestManager activates this quest immediately on game start.

@export var trigger_start_event	: EventResource
	# The EventResource that causes this quest to activate when fired.
	# Leave null for quests that auto_start or are activated manually.

@export var trigger_fail_event	: EventResource
	# Optional. When fired, this quest fails immediately (regardless of
	# progress or deadline). Parallel to trigger_start_event — events drive
	# state, the quest itself is agnostic about meaning. Examples: an NPC
	# offended beyond repair, a cargo crate destroyed, a rival finishes first.
	# Leave null if the quest can only fail via deadline expiry.

# Claude review: QuestManager.completed_quests and failed_quests store only the
# quest ID string. Once a quest leaves active_quests, this resource reference is
# lost. If we need a quest log showing past descriptions/objectives, or want to
# query details of a finished quest, we'll need to either retain the resource
# reference in those arrays or maintain a lookup table to resolve IDs back to
# Quest resources.
@export var completion_event	: EventResource
@export var failure_event		: EventResource

@export var dialogue_by_npc	: Dictionary = {}
	# Per-NPC dialogue lines tied to this quest, keyed by Character.id.
	# Example: { "npc_taxman": "Just the coin. Now." }
	# Consumed once per (quest, npc) — see PolishRefactor notes in quest_manager.gd.
