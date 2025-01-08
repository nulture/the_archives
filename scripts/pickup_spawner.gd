
class_name PickupSpawner extends CollisionObject3D

@export var spawn_prefab : PackedScene
@export var random_rotation : bool

func spawn(at_position: Vector3, at_rotation: Vector3) -> RigidBody3D:
	print(at_position)
	var result : RigidBody3D = spawn_prefab.instantiate()
	self.get_parent().add_child(result)
	result.global_position = at_position
	result.global_rotation = at_rotation
	if random_rotation:
		result.rotation_degrees.y += 90.0
	return result