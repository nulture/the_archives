
class_name PickupSpawner extends Grabbable

@export var spawn_prefab : PackedScene

func _grab(at_position: Vector3, at_rotation: Vector3) -> PhysicsBody3D:
	var result : RigidBody3D = spawn_prefab.instantiate()
	self.get_parent().add_child(result)
	result.global_position = at_position
	result.global_rotation = at_rotation * Vector3.UP
	return result