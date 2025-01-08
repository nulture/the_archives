
class_name PickupSpawner extends CollisionObject3D

@export var spawn_prefab : PackedScene

func spawn(at_position: Vector3, at_rotation: Vector3) -> RigidBody3D:
	var result : RigidBody3D = spawn_prefab.instantiate()
	self.get_parent().add_child(result)
	result.global_position = at_position
	result.global_rotation = at_rotation * Vector3.UP
	return result