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
var _interact_npc: Node = null
var _base_zoom: Vector2
var _interact_target_zoom: Vector2
const CAMERA_LERP_SPEED := 3.0
@export var interact_zoom_multiplier := 1.2
# Target on-screen position for the focused NPC, as a ratio of the viewport.
# (0.3, 0.5) means 30% from the left, vertically centered — keeps the NPC
# clear of the interaction popup on the right side.
@export var interact_npc_screen_ratio := Vector2(0.3, 0.5)

func _ready():
	# Register player_node with game_controller
	GameController.register_player(self)
	_base_zoom = _camera.zoom

# Player-specific input handling
func _physics_process(delta: float):
	if _is_interacting and _interact_npc:
		# Lerp zoom first so the ratio math below uses the in-progress zoom value.
		_camera.zoom = _camera.zoom.lerp(_interact_target_zoom, CAMERA_LERP_SPEED * delta)
		# Compute where the camera's screen center needs to be (in world units) so
		# the NPC lands at interact_npc_screen_ratio of the viewport. Screen offsets
		# are divided by current zoom to convert screen pixels into world units.
		var vp: Vector2 = get_viewport_rect().size
		var target_screen_pos: Vector2 = vp * interact_npc_screen_ratio
		var screen_center: Vector2 = vp * 0.5
		var world_shift: Vector2 = (screen_center - target_screen_pos) / _camera.zoom
		var target_camera_world: Vector2 = _interact_npc.global_position + world_shift
		var target_offset: Vector2 = target_camera_world - global_position
		_camera.offset = _camera.offset.lerp(target_offset, CAMERA_LERP_SPEED * delta)
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
	_interact_npc = npc
	_interact_target_zoom = _base_zoom * interact_zoom_multiplier

func unfocus() -> void:
	_is_interacting = false
	_interact_npc = null
