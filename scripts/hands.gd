
class_name Hands extends Node

@export var cast : RayCast3D
@export var hand_right : Area3D
@export var hand_left : Area3D
@export var target_node : Node3D

@onready var camera : Camera3D = self.get_parent()
@onready var origins : Dictionary = {
	hand_right: hand_right.get_parent(),
	# hand_left : hand_left.get_parent(),
}

var hand_mouse_input : Vector2

var _reaching_hand : Area3D
var reaching_hand : Area3D :
	get: return _reaching_hand
	set(value):
		if _reaching_hand == value: return
		
		if _reaching_hand:
			_reaching_hand.get_parent().remove_child(_reaching_hand)
			origins[_reaching_hand].add_child(_reaching_hand)
			# stored_position = _reaching_hand.position
			_reaching_hand.position = Vector3.ZERO
		# else:
			# target_node.position = Vector3.ZERO

		_reaching_hand = value
		# target_node.position = target_node.position * Vector3.FORWARD

		if _reaching_hand:
			_reaching_hand.get_parent().remove_child(_reaching_hand)
			camera.add_child(_reaching_hand)
			_reaching_hand.global_position = target_node.global_position


var is_reaching : bool :
	get: return _reaching_hand != null


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hand_right"):
		reaching_hand = hand_right
	elif event.is_action_released("hand_right"):
		reaching_hand = null
	
	if event is InputEventMouseMotion:
		hand_mouse_input = event.relative


func _process(delta: float) -> void:
	if reaching_hand:
		reaching_hand.position += Vector3(hand_mouse_input.x, -hand_mouse_input.y, 0.0) * delta
		reaching_hand.position = reaching_hand.position.limit_length()
		# cast.target_position = reaching_hand.position
	hand_mouse_input = Vector2.ZERO