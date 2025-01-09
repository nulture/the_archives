
class_name Grabbable extends CollisionObject3D

@export var physics_handle_motion : bool = true
@export var take_with_you : bool = true

var owning_hand : Hand
var is_grabbed : bool :
	get: return owning_hand != null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func grab(at_position: Vector3, at_rotation: Vector3) -> PhysicsBody3D: return self._grab(at_position, at_rotation)
func _grab(at_position: Vector3, at_rotation: Vector3) -> PhysicsBody3D:
	var this = self
	return this if this is PhysicsBody3D else null
