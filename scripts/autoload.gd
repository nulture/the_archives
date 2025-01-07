
extends Node

var _is_fullscreen_exclusive : bool = false
var is_fullscreen_exclusive : bool :
	get: return _is_fullscreen_exclusive
	set(value):
		_is_fullscreen_exclusive = value
		self.is_fullscreen = self.is_fullscreen

var fullscreen_mode : Window.Mode :
	get:
		if is_fullscreen_exclusive:
			return Window.MODE_EXCLUSIVE_FULLSCREEN
		else:
			return Window.MODE_FULLSCREEN

var is_fullscreen : bool :
	get: return get_window().mode == Window.MODE_FULLSCREEN or get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN
	set(value):
		if value:
			get_window().mode = self.fullscreen_mode
		else:
			get_window().mode = Window.MODE_WINDOWED


func _ready() -> void:
	if not OS.is_debug_build(): self.is_fullscreen = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		self.get_tree().quit()
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# if event.is_action_pressed("fullscreen_exclusive"):
	# 	self.is_fullscreen_exclusive = true
	# 	self.is_fullscreen = not self.is_fullscreen
	# elif event.is_action_pressed("fullscreen"):
	if event.is_action_pressed("fullscreen"):
		self.is_fullscreen_exclusive = false
		self.is_fullscreen = not self.is_fullscreen