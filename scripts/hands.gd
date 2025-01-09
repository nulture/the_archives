
class_name Hands extends Node

@export var hand_right : Hand
@export var hand_left : Hand

@export var arm_length := 2.0
@export_flags_3d_physics var mask : int

@onready var camera : Camera3D = self.get_parent()

var _reached_object : CollisionObject3D

var _is_reaching : bool
var is_reaching : bool :
	get: return _is_reaching
	set(value):
		if _is_reaching == value: return
		_is_reaching = value

		if _is_reaching:
			pass
		else:
			if hand_right.grabbed_body and not hand_right.grabbed_body.take_with_you:
				hand_right.grabbed_body = null

			hand_right.position = Vector3.ZERO
			is_indexing = false
			is_rotating = false

var _is_indexing : bool
var is_indexing : bool :
	get: return _is_indexing
	set(value):
		if _is_indexing == value: return
		_is_indexing = value

		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN if _is_indexing else Input.MOUSE_MODE_CAPTURED



var _is_rotating : bool
var is_rotating : bool :
	get: return _is_rotating
	set(value):
		if _is_rotating == value: return
		_is_rotating = value

var previous_camera_rotation : Vector3
var delta_camera_rotation : Vector3
func _physics_process(delta: float) -> void:
	delta_camera_rotation = camera.global_rotation - previous_camera_rotation
	previous_camera_rotation = camera.global_rotation


func _process(delta: float) -> void:
	_reached_object = null
	if is_reaching:
		var mouse_position := get_viewport().get_mouse_position()
		var space := camera.get_world_3d().direct_space_state
		var rqp := PhysicsRayQueryParameters3D.new()
		rqp.from = camera.global_position
		rqp.to = rqp.from + camera.project_ray_normal(mouse_position) * arm_length
		rqp.collision_mask = mask
		rqp.collide_with_areas = true
		var result := space.intersect_ray(rqp)

		if not is_rotating:
			if result.is_empty():
				hand_right.global_position = rqp.to
			else:
				hand_right.global_position = result["position"]
				if result["collider"] is CollisionObject3D:
					_reached_object = result["collider"]


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hand_right"):
		is_reaching = true
	elif event.is_action_released("hand_right"):
		is_reaching = false

	if is_reaching:
		if event.is_action_pressed("hand_modifier"):
			is_rotating = true
		if event.is_action_released("hand_modifier"):
			is_rotating = false

		if event.is_action_pressed("hand_left"):
			if hand_right.grabbed_body:
				try_release()
			else:
				try_grab()
		elif event.is_action_released("hand_left"):
			if hand_right.grabbed_body and not hand_right.grabbed_body.take_with_you:
				try_release()


func try_grab() -> void:
	if _reached_object is Grabbable:
		_reached_object = _reached_object.grab(hand_right.global_position, camera.global_rotation)
		hand_right.grabbed_body = _reached_object
		hand_right.position *= 0.75



func try_release() -> void:
	if not hand_right.grabbed_body: return
	hand_right.grabbed_body = null
	hand_right.position *= 1.0 / 0.75