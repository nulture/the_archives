
extends PickupSpawner

@export var starting_char : String = "A"
@export var genre : String = "General"
@export_range(0, 1, 0.05) var backwards_chance : float = 0.05

func grab(at_position: Vector3, at_rotation: Vector3) -> RigidBody3D:
	var result := super.grab(at_position, at_rotation)
	if randf() < backwards_chance:
		result.rotation_degrees.y -= 90.0
	else:
		result.rotation_degrees.y += 90.0
	return result

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
