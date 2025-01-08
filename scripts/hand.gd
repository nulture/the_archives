
class_name Hand extends PhysicsBody3D

@export var hands : Hands

@onready var grip_joint : JoltGeneric6DOFJoint3D = $grip_joint

var mouse_input : Vector2

var stored_collision_layer : int
var stored_collision_mask : int
var stored_angular_damp : float
var _grabbed_body : Grabbable
var grabbed_body : Grabbable :
	get: return _grabbed_body
	set(value):
		if _grabbed_body == value: return
		
		if _grabbed_body:
			_grabbed_body.angular_damp = stored_angular_damp
			_grabbed_body.collision_layer = stored_collision_layer
			_grabbed_body.collision_mask = stored_collision_mask

		_grabbed_body = value
		# self.rotation = Vector3.ZERO

		if _grabbed_body:
			stored_angular_damp = _grabbed_body.angular_damp
			stored_collision_layer = _grabbed_body.collision_layer
			stored_collision_mask = _grabbed_body.collision_mask

			_grabbed_body.angular_damp = 30.0

			if _grabbed_body.take_with_you:
				_grabbed_body.global_position = self.global_position
				_grabbed_body.collision_layer = 0
				_grabbed_body.set_collision_mask_value(3, false)
			
		grip_joint.node_b = _grabbed_body.get_path() if _grabbed_body != null else ^""


func _physics_process(delta: float) -> void:
	if hands.is_rotating:
		if grabbed_body:
			grabbed_body.apply_torque(hands.camera.global_basis.x * mouse_input.y)
			grabbed_body.apply_torque(hands.camera.global_basis.y * mouse_input.x)
		# self.global_rotate(hands.camera.global_basis.x, mouse_input.y * delta)
		# self.global_rotate(hands.camera.global_basis.y, mouse_input.x * delta)
	mouse_input = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_input = event.relative
