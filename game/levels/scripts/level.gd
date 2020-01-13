extends Node2D

# Child nodes
onready var _camera = $Camera2D
onready var _ground = $Ground

################################################################################
# BUILT-IN VIRTUAL METHODS (CANNOT OVERRIDE)
################################################################################

func _ready():
	_set_camera_limits()

################################################################################
# PRIVATE METHODS
################################################################################

func _set_camera_limits():
	var map_limits = _ground.get_used_rect()
	var map_cell_size = _ground.cell_size
	var limits = {
		'left': map_limits.position.x * map_cell_size.x,
		'right': map_limits.end.x * map_cell_size.x,
		'top': map_limits.position.y * map_cell_size.y,
		'bottom': map_limits.end.y * map_cell_size.y,
	}
	_camera.set_limits(limits)
