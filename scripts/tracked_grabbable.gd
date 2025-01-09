
extends Grabbable

@onready var follower : PathFollow3D = self.get_parent()
@onready var path : Path3D = self.get_parent().get_parent()

@export var damping : float = 1.0
@export var max_velocity : float = 50.0

var _velocity : float
var velocity : float :
	get: return _velocity
	set(value):
		value = clamp(value, -max_velocity, max_velocity)
		if _velocity == value: return
		_velocity = value


func _physics_process(delta: float) -> void:
	if is_grabbed:
		var offset = path.curve.get_closest_offset(path.to_local(owning_hand.global_position))
		velocity = (offset - follower.progress) / delta
		follower.progress = offset
	else:
		follower.progress += velocity * delta
		velocity -= velocity * damping * delta


func _grab(at_position: Vector3, at_rotation: Vector3) -> PhysicsBody3D:
	return super._grab(at_position, at_rotation)
