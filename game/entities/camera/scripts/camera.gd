extends Camera2D

# Panning
export (float) var pan_speed = 200.0
var _mouse_pos = Vector2.ZERO

# Zooming
export (float) var zoom_speed = 0.5
export (float) var zoom_step = 0.1
export (float) var zoom_min = 0.5
export (float) var zoom_max = 2.0

# Display
var _display_size = Vector2.ZERO
var _x_offset = 0.0
var _y_offset = 0.0
var _screenedge_margin = 100.0

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
	_check_key_inputs(delta)
	_check_mouse_inputs(delta)

#-------------------------------------------------------------------------------

func _ready():
	_adjust_screenedge_offset()

################################################################################
# PRIVATE METHODS
################################################################################

func _adjust_screenedge_offset():
	"""
	Sets the camera offsets from the screenedges.
	
	Note that this function is highly necessary to drag the viewport with the 
	camera's position. Failure to do so will result in viewport screen drag
	delays. The method should be called at runtime and anytime the camera's
	zoom parameter is updated.
	"""
	if not _display_size:
		_display_size = Utils.get_display_size()
		
	_x_offset = _display_size.x / 2 * zoom.x
	_y_offset = _display_size.y / 2 * zoom.y

#-------------------------------------------------------------------------------

func _check_key_inputs(delta):
	"""
	Checks the WASD keys to determine if the camera should pan.
	"""
	var x_input = int(Input.is_action_pressed('pan_right')) - \
		int(Input.is_action_pressed('pan_left'))
	var y_input = int(Input.is_action_pressed('pan_down')) - \
		int(Input.is_action_pressed('pan_up'))
	var new_position = position + (Vector2(x_input, y_input).normalized() * \
		pan_speed * zoom * delta)
	
	position.x = lerp(position.x, new_position.x, pan_speed * delta)
	position.y = lerp(position.y, new_position.y, pan_speed * delta)
	
	# Clamp values
	position.x = clamp(position.x, _x_offset, limit_right - _x_offset)
	position.y = clamp(position.y, _y_offset, limit_bottom - _y_offset)

#-------------------------------------------------------------------------------

func _check_mouse_inputs(delta):
	"""
	Checks the mouse position against the screenedge margin to determine if the
	camera should pan.
	"""
	if _mouse_pos.x < _screenedge_margin:
		position.x = lerp(position.x, position.x - pan_speed * zoom.x * delta, 
			pan_speed * delta)
	elif _mouse_pos.x > _display_size.x - _screenedge_margin:
		position.x = lerp(position.x, position.x + pan_speed * zoom.x * delta, 
			pan_speed * delta)
	
	if _mouse_pos.y < _screenedge_margin:
		position.y = lerp(position.y, position.y - pan_speed * zoom.y * delta, 
			pan_speed * delta)
	elif _mouse_pos.y > _display_size.y - _screenedge_margin:
		position.y = lerp(position.y, position.y + pan_speed * zoom.y * delta, 
			pan_speed * delta)
	
	# Clamp values
	position.x = clamp(position.x, _x_offset, limit_right - _x_offset)
	position.y = clamp(position.y, _y_offset, limit_bottom - _y_offset)

#-------------------------------------------------------------------------------

func _check_zoom(event):
	"""
	Checks mouse button events to determine if the camera should be zooming.
	"""
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				zoom.x = lerp(zoom.x, zoom.x - zoom_step, zoom_speed)
				zoom.y = lerp(zoom.y, zoom.y - zoom_step, zoom_speed)
			elif event.button_index == BUTTON_WHEEL_DOWN:
				zoom.x = lerp(zoom.x, zoom.x + zoom_step, zoom_speed)
				zoom.y = lerp(zoom.y, zoom.y + zoom_step, zoom_speed)
			
			zoom.x = clamp(zoom.x, zoom_min, zoom_max)
			zoom.y = clamp(zoom.y, zoom_min, zoom_max)
			_adjust_screenedge_offset()
	
	if event is InputEventMouseMotion:
		_mouse_pos = event.position

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
	Sets the map boundary limits for the camera and viewport.
	
	Args:
		- limits (Dictionary): Holds the left, right, top, and bottom limits for
			the camera. Limits are 'int' types.
	"""
	var display_size = Utils.get_display_size()
	
	limit_left = limits['left']
	limit_right = limits['right']
	limit_top = limits['top']
	limit_bottom = limits['bottom']
