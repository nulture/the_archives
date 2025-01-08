
class_name Hand extends CollisionObject3D

@export var hands : Hands

@onready var grip_joint : Generic6DOFJoint3D = $grip_joint

var mouse_input : Vector2

var stored_collision_layer : int
var stored_collision_mask : int
var _grabbed_body : RigidBody3D
var grabbed_body : RigidBody3D :
	get: return _grabbed_body
	set(value):
		if _grabbed_body == value: return
		
		if _grabbed_body:
			_grabbed_body.collision_layer = stored_collision_layer
			_grabbed_body.collision_mask = stored_collision_mask

		_grabbed_body = value
		grip_joint.node_b = _grabbed_body.get_path() if _grabbed_body != null else ^""

		if _grabbed_body:
			stored_collision_layer = _grabbed_body.collision_layer
			stored_collision_mask = _grabbed_body.collision_mask

			_grabbed_body.collision_layer = 0
			_grabbed_body.set_collision_mask_value(3, false)


func _process(delta: float) -> void:
	if hands.is_rotating:
		self.global_rotate(hands.camera.global_basis.x, mouse_input.y * delta)
		self.global_rotate(hands.camera.global_basis.y, mouse_input.x * delta)
	mouse_input = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_input = event.relative
