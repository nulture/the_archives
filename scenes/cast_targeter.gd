
@tool
extends RayCast3D

@export var target_node : Node3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	target_position = target_node.position
