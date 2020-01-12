tool
extends TileMap

################################################################################
# BUILT-IN VIRTUAL METHODS (CANNOT OVERRIDE)
################################################################################

func _get_configuration_warning():
	"""
	Returns a configuration warning if certain editor parameters have not been
	met.
	
	Returns:
		- warning (String)
	"""
	var warning = ""
	
	if not tile_set:
		warning = "A tileset for this TileMap node has not yet been loaded."
	
	return warning
