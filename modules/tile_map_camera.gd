class_name TileMapCamera
extends Camera2D

@export
var tilemap: TileMap

func _ready():
	var map_limits = tilemap.get_used_rect()
	var map_cellsize = tilemap.cell_quadrant_size
	limit_left = map_limits.position.x * map_cellsize
	limit_right = map_limits.end.x * map_cellsize
	limit_top = map_limits.position.y * map_cellsize
	limit_bottom = map_limits.end.y * map_cellsize
