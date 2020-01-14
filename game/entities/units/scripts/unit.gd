extends KinematicBody2D

# Child nodes
onready var _select_circle = $SelectionCircle
onready var _sprite = $Sprite

# Movement
onready var _nav = get_tree().get_nodes_in_group('navigation').pop_front()
export (float) var move_speed = 0.0
export (float) var min_arrival_distance = 0.0
var _velocity = Vector2.ZERO
var _path = []


# Selection
var is_selected = false setget set_is_selected

# Targetting
var target = null setget set_target

################################################################################
# BUILT-IN VIRTUAL METHODS (CANNOT OVERRIDE)
################################################################################

func _physics_process(delta):
	if _path:
		_navigate_through_path(delta)

#-------------------------------------------------------------------------------

func _ready():
	_initialize()

################################################################################
# PRIVATE METHODS
################################################################################

func _initialize():
	_update_selection_circle()

#-------------------------------------------------------------------------------

func _make_new_path():
	_path = Array(_nav.get_simple_path(position, target, true))
	target = null

#-------------------------------------------------------------------------------

func _navigate_through_path(delta):
	var distance = position.distance_to(_path[0])
	
	if distance > min_arrival_distance:
		var direction = (_path[0] - position).normalized()
		_velocity = direction * move_speed
		move_and_slide(_velocity)
	else:
		if _path.size() > 1:
			_path.pop_front()

#-------------------------------------------------------------------------------

func _update_selection_circle():
	if is_selected:
		_select_circle.show()
	else:
		_select_circle.hide()

################################################################################
# SETTERS
################################################################################

func set_is_selected(value):
	is_selected = value
	_update_selection_circle()

#-------------------------------------------------------------------------------

func set_target(value):
	target = value
	if target:
		_make_new_path()
