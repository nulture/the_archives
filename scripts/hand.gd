extends Area3D

@onready var origin_node : Node3D = self.get_parent()

@export var is_right_hand : bool
@export var target_node : Node3D

var stored_position : Vector3

var _is_reaching : bool
var is_reaching : bool :
	get: return _is_reaching
	set(value):
		if _is_reaching == value: return
		_is_reaching = value

		get_parent().remove_child(self)
		if _is_reaching:
			target_node.add_child(self)
			position = stored_position
		else:
			origin_node.add_child(self)
			stored_position = position
			position = Vector3.ZERO


func _input(event: InputEvent) -> void:
	if is_right_hand:
		pass
		if event.is_action_pressed("hand_right"):
			is_reaching = true
		elif event.is_action_released("hand_right"):
			is_reaching = false
	else:
		if event.is_action_pressed("hand_left"):
			is_reaching = true
		elif event.is_action_released("hand_left"):
			is_reaching = false
		


