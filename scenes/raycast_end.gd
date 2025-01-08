
@tool
extends Node3D

# @export var cast_parent : RayCast3D
@onready var cast_parent : RayCast3D = self.get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# print(cast_parent.get_collision_point())
	if cast_parent.is_colliding():
		self.global_position = cast_parent.get_collision_point()
	else:
		self.position = cast_parent.target_position
