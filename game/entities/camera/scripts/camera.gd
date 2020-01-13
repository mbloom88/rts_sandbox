extends Camera2D

# Panning
export (float) var pan_speed = 0.0

# Zooming
export (float) var zoom_factor = 0.0
export (float) var zoom_speed = 0.0
export (float) var zoom_margin = 0.0
var _zoom_pos = Vector2()

# Debug
var _is_debugging = false

################################################################################
# BUILT-IN VIRTUAL METHODS (CANNOT OVERRIDE)
################################################################################

func _draw():
	if _is_debugging:
		draw_circle(position, 50, Color.red)

#-------------------------------------------------------------------------------

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
	var x_input = int(Input.is_action_pressed('pan_right')) - \
		int(Input.is_action_pressed('pan_left'))
	var y_input = int(Input.is_action_pressed('pan_down')) - \
		int(Input.is_action_pressed('pan_up'))
	
	var new_position = position + (Vector2(x_input, y_input).normalized() * \
		pan_speed * delta)
	
	position.x = clamp(lerp(position.x, new_position.x, pan_speed * delta),
		limit_left, limit_right)
	position.y = clamp(lerp(position.y, new_position.y, pan_speed * delta),
		limit_top, limit_bottom)

#-------------------------------------------------------------------------------

func _check_zoom(event):
	var mouse_pos = get_global_mouse_position()
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				zoom.x = clamp(zoom.x - zoom_factor, 1.0, 2.0)
				zoom.y = clamp(zoom.y - zoom_speed, 1.0, 2.0)
				position = mouse_pos
			elif event.button_index == BUTTON_WHEEL_DOWN:
				zoom.x = clamp(zoom.x + zoom_speed, 1.0, 2.0)
				zoom.y = clamp(zoom.y + zoom_speed, 1.0, 2.0)
				position = mouse_pos

################################################################################
# PUBLIC METHODS
################################################################################

func activate_debug_mode():
	_is_debugging = true
	update()

#-------------------------------------------------------------------------------

func deactivate_debug_mode():
	_is_debugging = false
	update()

#-------------------------------------------------------------------------------

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
