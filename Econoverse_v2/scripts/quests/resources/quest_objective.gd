extends Resource
class_name QuestObjective

enum ObjectiveType { GIVE, GET, COLLECT, MEET, ELAPSE, VISIT }

@export var id : String = ""
@export var objective_type : ObjectiveType = ObjectiveType.MEET
@export var description : String = ""
@export var target_id : String = ""
@export var item_id : String = ""
@export var required_quantity : int = 0
