extends Node2D

# Unit selection
var _is_dragging = false
var _selected_units = []
var _drag_start = Vector2.ZERO
var _drag_end = Vector2.ZERO
var _select_rect = RectangleShape2D.new()
var _select_point = CircleShape2D.new()
var _point_radius = 0.01
var _rect_color = Color.blue

################################################################################
# BUILT-IN VIRTUAL METHODS (CANNOT OVERRIDE)
################################################################################

func _draw():
	if _is_dragging:
		draw_rect(Rect2(_drag_start, get_global_mouse_position() - _drag_start),
			_rect_color, false)

#-------------------------------------------------------------------------------

func _unhandled_input(event):
	_check_mouse_click(event)
	_check_mouse_motion(event)

################################################################################
# PRIVATE METHODS
################################################################################

func _check_mouse_click(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			if Input.is_key_pressed(KEY_CONTROL):
				var mouse_pos = get_global_mouse_position()
				var space = get_world_2d().direct_space_state
				var query = Physics2DShapeQueryParameters.new()
				_select_point.radius = _point_radius
				query.set_shape(_select_point)
				query.transform = Transform2D(0, mouse_pos)
				var new_selections = space.intersect_shape(query)
				for dict_item in new_selections:
					if dict_item.collider in _selected_units:
						dict_item.collider.is_selected = false
						_selected_units.erase(dict_item.collider)
					else:
						dict_item.collider.is_selected = true
						_selected_units.append(dict_item.collider)
			else:
				_selected_units.clear()
				get_tree().call_group('units', 'set_is_selected', false)
				_is_dragging = true
				_drag_start = get_global_mouse_position()
		elif _is_dragging:
			_is_dragging = false
			update()
			_drag_end = get_global_mouse_position()
			_select_rect.extents = (_drag_end - _drag_start) / 2
			var space = get_world_2d().direct_space_state
			var query = Physics2DShapeQueryParameters.new()
			query.set_shape(_select_rect)
			query.transform = Transform2D(0, (_drag_end + _drag_start) / 2)
			var new_selections = space.intersect_shape(query)
			for dict_item in new_selections:
				_selected_units.append(dict_item.collider)
				dict_item.collider.is_selected = true
	
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if event.is_pressed():
			for unit in _selected_units:
				unit.target = get_global_mouse_position()

#-------------------------------------------------------------------------------

func _check_mouse_motion(event):
	if event is InputEventMouseMotion and _is_dragging:
		update()