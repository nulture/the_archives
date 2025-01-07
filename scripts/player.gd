
extends RigidBody3D

const JUMP_VELOCITY = 4.5

@onready var pov : Node3D = $pov
@onready var floor_sensor : ShapeCast3D = $floor_sensor
@onready var ledge_sensor : ShapeCast3D = $ledge_sensor

@export var walk_slow_speed : float = 40.0
@export var walk_fast_speed : float = 60.0
@export var walk_damp : float = 7.0
@export_range(0, 1, 0.025) var walk_air_control : float = 0.125

@export var turn_speed : float = 1.0
@export var mouse_turn_speed : float = 1.0

@export var jump_strength : float = 4.0
@export var ledgegrab_strength : float = 6.0

var turn_mouse_axis : Vector2

var is_ledgegrab_exhausted

var _is_sprinting : bool
var is_sprinting : bool :
	get: return _is_sprinting
	set(value):
		if _is_sprinting == value: return
		_is_sprinting = value


var is_on_floor : bool :
	get: return floor_sensor.is_colliding()


var walk_speed : float :
	get: return walk_fast_speed if is_sprinting else walk_slow_speed


func _ready() -> void:
	# floor_sensor.
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("sprint"):
		is_sprinting = true
	elif event.is_action_released("sprint"):
		is_sprinting = false
	elif event.is_action_pressed("jump"):
		try_jump()

	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		turn_mouse_axis = -event.relative


func _physics_process(delta: float) -> void:
	var turn_axis := Input.get_vector("look_left", "look_right", "look_up", "look_down")

	self.rotation += Vector3.UP * (turn_mouse_axis.x * mouse_turn_speed + turn_axis.x * turn_speed) * delta
	pov.rotation += Vector3.RIGHT * (turn_mouse_axis.y * mouse_turn_speed + turn_axis.y * turn_speed) * delta
	pov.rotation_degrees = Vector3(clamp(pov.rotation_degrees.x, -90, 90), pov.rotation_degrees.y, pov.rotation_degrees.z)
	turn_mouse_axis = Vector2.ZERO

	var walk_axis := Input.get_vector("strafe_left", "strafe_right", "walk_forward", "walk_back")
	var walk_vector := (transform.basis * Vector3(walk_axis.x, 0, walk_axis.y))

	var floor_scalar = 1.0 if is_on_floor else walk_air_control
	self.apply_force(walk_vector * walk_speed * floor_scalar)
	self.apply_force(-self.linear_velocity * (Vector3.ONE - Vector3.UP) * walk_damp * floor_scalar)

	if is_on_floor:
		is_ledgegrab_exhausted = false
	elif walk_axis:
		try_ledgegrab()

func try_ledgegrab() -> void:
	if is_ledgegrab_exhausted or is_on_floor or self.linear_velocity.y >= 0.0 or not ledge_sensor.is_colliding(): return


	self.linear_velocity = self.linear_velocity * (Vector3.ONE - Vector3.UP)
	self.apply_impulse(Vector3.UP * ledgegrab_strength)
	is_ledgegrab_exhausted = true


func try_jump() -> void:
	if not is_on_floor: return
	self.apply_impulse(Vector3.UP * jump_strength)