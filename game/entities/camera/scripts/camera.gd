extends Camera2D

# Camera
export (float) var pan_speed = 0.0
export (float) var zoom_speed = 0.0

################################################################################
# BUILT-IN VIRTUAL METHODS (CANNOT OVERRIDE)
################################################################################

func _unhandled_input(event):
	_check_zoom(event)

#-------------------------------------------------------------------------------

func _process(delta):
	update()
	_check_inputs(delta)

################################################################################
# PUBLIC METHODS
################################################################################

func _check_inputs(delta):
	var display_size = Utils.get_display_size()
	var right_stop = limit_right - (display_size.x * zoom.x) 
	var bottom_stop = limit_bottom  - (display_size.y * zoom.y) 
	
	if Input.is_action_pressed('pan_up'):
		position.y = clamp(position.y - pan_speed * delta, limit_top,
			bottom_stop)
	elif Input.is_action_pressed('pan_down'):
		position.y = clamp(position.y + pan_speed * delta, limit_top,
			bottom_stop)
		
	if Input.is_action_pressed('pan_left'):
		position.x = clamp(position.x - pan_speed * delta, limit_left,
			right_stop)
	elif Input.is_action_pressed('pan_right'):
		position.x = clamp(position.x + pan_speed * delta, limit_left,
			right_stop) 

#-------------------------------------------------------------------------------

func _check_zoom(event):
	var mouse_pos = get_global_mouse_position()
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				zoom.x = clamp(zoom.x - zoom_speed, 1.0, 2.0)
				zoom.y = clamp(zoom.y - zoom_speed, 1.0, 2.0)
				position = mouse_pos
			elif event.button_index == BUTTON_WHEEL_DOWN:
				zoom.x = clamp(zoom.x + zoom_speed, 1.0, 2.0)
				zoom.y = clamp(zoom.y + zoom_speed, 1.0, 2.0)
				position = mouse_pos

################################################################################
# PUBLIC METHODS
################################################################################

func set_limits(limits):
	"""
	Sets the map boundary limits for the camera.
	
	Args:
		- limits (Dictionary): Holds the left, right, top, and bottom limits for
			the camera. Limits are 'int' types.
	"""
	limit_left = limits['left']
	limit_right = limits['right']
	limit_top = limits['top']
	limit_bottom = limits['bottom']
