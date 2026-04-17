# --- player.gd ---
# This is the "Player" specific script.
# It inherits EVERYTHING from the Character Class (Class_Character.gd)

extends Character
# We can add player-specific logic here, like movement.
@export var speed: float = 300.0
@export var characters_met: Array[String] = [] #stores unique IDs of NPCs met
var _can_move: bool = true

# Camera interaction state
@onready var _camera: Camera2D = $Camera2D
var _is_interacting: bool = false
var _base_zoom: Vector2
var _interact_target_pos: Vector2
var _interact_target_zoom: Vector2
const CAMERA_LERP_SPEED := 3.0
@export var interact_zoom_multiplier := 1.2

func _ready():
	# Register player_node with game_controller
	GameController.register_player(self)
	_base_zoom = _camera.zoom

# Player-specific input handling
func _physics_process(delta: float):
	if _is_interacting:
		# Lerp camera offset toward the NPC's position relative to the player
		var target_offset := _interact_target_pos - global_position
		_camera.offset = _camera.offset.lerp(target_offset, CAMERA_LERP_SPEED * delta)
		_camera.zoom = _camera.zoom.lerp(_interact_target_zoom, CAMERA_LERP_SPEED * delta)
		velocity = Vector2.ZERO
		return
	# Lerp camera back to default when not interacting
	_camera.offset = _camera.offset.lerp(Vector2.ZERO, CAMERA_LERP_SPEED * delta)
	_camera.zoom = _camera.zoom.lerp(_base_zoom, CAMERA_LERP_SPEED * delta)
	if not _can_move:
		velocity = Vector2.ZERO
		return
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	if direction != Vector2.ZERO:
		#player moves along diagonal isometric axis
		var iso_direction = Vector2(direction.x, direction.y * 0.5)

		velocity = iso_direction.normalized() * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func focus_on_npc(npc: Node) -> void:
	_is_interacting = true
	_interact_target_pos = npc.global_position
	_interact_target_zoom = _base_zoom * interact_zoom_multiplier

func unfocus() -> void:
	_is_interacting = false
